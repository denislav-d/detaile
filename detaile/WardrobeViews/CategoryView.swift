//
//  CategoryView.swift
//  detaile
//
//  Created by Denislav Dimitrov on 16.02.25.
//

import SwiftUI
import SwiftData

struct CategoryView: View {
    @Query private var categories: [WardrobeCategory]
    @State private var selectedTab = 0
    @State private var favorites: [WardrobeItem] = []
    @State private var isPresentingAddItem = false

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Category", selection: $selectedTab) {
                    Text("Categories").tag(0)
                    Text("Favorites").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()

                if selectedTab == 0 {
                    List(categories) { category in
                        NavigationLink(destination: CategoryDetailView(category: category, favorites: $favorites)) {
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.name)
                                    .font(.headline)
                            }
                            .padding(.vertical)
                        }
                    }
                } else {
                    FavoritesView(favorites: $favorites)
                }
            }
            .navigationTitle("Wardrobe")
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
}

#Preview {
    CategoryView()
        .modelContainer(for: [WardrobeItem.self, WardrobeCategory.self], inMemory: true)
}
