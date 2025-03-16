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

    @State private var selectedSort: SortOption = .recentlyAdded
    @State private var selectedColor: String? = nil
    @State private var selectedBrand: String? = nil
    @State private var selectedType: String? = nil
    @State private var showRefineSheet = false
    @State private var isPresentingAddItem = false

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
                        NavigationLink(destination: WardrobeItemDetailView(item: item, favorites: $favorites)) {
                            WardrobeItemCard(item: item)
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isPresentingAddItem = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isPresentingAddItem) {
            AddItemView()
        }
    }
}

// Dummy implementations for required types/views:

enum SortOption { case recentlyAdded, aToZ, zToA }
