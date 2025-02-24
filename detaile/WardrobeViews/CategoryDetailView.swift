//
//  CategoryDetailView.swift
//  detaile
//
//  Created by Denislav Dimitrov on 24.02.25.
//

import SwiftUI

struct CategoryDetailView: View {
    let category: WardrobeCategory
    @Binding var favorites: [WardrobeItem]

    // Sort/Filter State
    @State private var selectedSort: SortOption = .recentlyAdded
    @State private var selectedColor: String? = nil
    @State private var selectedBrand: String? = nil
    @State private var selectedType: String? = nil
    @State private var showRefineSheet = false

    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)

    var sortedAndFilteredItems: [WardrobeItem] {
        // 1. Filter
        var filtered = category.items

        if let selectedColor = selectedColor {
            filtered = filtered.filter { item in
                item.colors.contains(selectedColor)
            }
        }
        if let brand = selectedBrand {
            filtered = filtered.filter { $0.brand == brand }
        }
        if let type = selectedType {
            filtered = filtered.filter { $0.type == type }
        }

        // 2. Sort
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
                Button("Refine", systemImage: "line.3.horizontal.decrease") {
                    showRefineSheet.toggle()
                }
                .padding()
                Spacer()
            }

            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(sortedAndFilteredItems) { item in
                        ItemCard(item: item, favorites: $favorites)
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
    }
}

//#Preview {
//    CategoryDetailView()
//}
