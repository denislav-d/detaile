//
//  CategoryDetailView.swift
//  detaile
//
//  Created by Denislav Dimitrov on 24.02.25.
//

import SwiftUI
import SwiftData

struct CategoryDetailView: View {
    let category: WardrobeCategory
    @Binding var favorites: [WardrobeItem]
    @Environment(\.modelContext) private var modelContext

    @State private var selectedSort: SortOption = .recentlyAdded
    @State private var selectedColor: String? = nil
    @State private var selectedBrand: String? = nil
    @State private var selectedType: String? = nil
    @State private var showRefineSheet = false
    @State private var isEditing = false
    @State private var itemToDelete: WardrobeItem? = nil
    @State private var showDeleteConfirmation = false

    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)

    var sortedAndFilteredItems: [WardrobeItem] {
        var filtered = category.items

        if let selectedColor = selectedColor {
            filtered = filtered.filter { $0.colors.contains(selectedColor) }
        }
        if let brand = selectedBrand {
            filtered = filtered.filter { $0.brand == brand }
        }
        if let type = selectedType {
            filtered = filtered.filter { $0.type == type }
        }

        switch selectedSort {
        case .recentlyAdded:
            return filtered.sorted { $0.dateAdded > $1.dateAdded }
        case .aToZ:
            return filtered.sorted { $0.title < $1.title }
        case .zToA:
            return filtered.sorted { $0.title > $1.title }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        showRefineSheet.toggle()
                    } label: {
                        Label("Refine", systemImage: "line.3.horizontal.decrease")
                    }
                    .padding()
                    Spacer()
                }
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(sortedAndFilteredItems) { item in
                            if isEditing {
                                ItemEditView(item: item, isEditing: isEditing) {
                                    itemToDelete = item
                                    showDeleteConfirmation = true
                                }
                            } else {
                                NavigationLink(destination: WardrobeItemDetailView(item: item, favorites: $favorites)) {
                                    WardrobeItemCard(item: item)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(category.name)
            .sheet(isPresented: $showRefineSheet) {
                RefineView(
                    items: category.items,
                    selectedSort: $selectedSort,
                    selectedColor: $selectedColor,
                    selectedBrand: $selectedBrand,
                    selectedType: $selectedType
                )
                .presentationDetents([.height(500), .large])
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation { isEditing.toggle() }
                    } label: {
                        Text(isEditing ? "Done" : "Edit")
                    }

                    NavigationLink(destination: AddItemView()) {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Delete Item?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let item = itemToDelete {
                        deleteItem(item)
                    }
                }
            } message: {
                Text("Are you sure you want to delete this item? This action cannot be undone.")
            }
        }
    }

    private func deleteItem(_ item: WardrobeItem) {
        if let index = category.items.firstIndex(where: { $0.id == item.id }) {
            withAnimation {
                category.items.remove(at: index)
                modelContext.delete(item)
            }
        }
    }
}

enum SortOption { case recentlyAdded, aToZ, zToA }
