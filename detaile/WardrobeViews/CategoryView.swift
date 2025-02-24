//
//  CategoryView.swift
//  detaile
//
//  Created by Denislav Dimitrov on 16.02.25.
//

import SwiftUI

struct CategoryView: View {
    @StateObject private var viewModel = WardrobeViewModel()
    @State private var selectedTab = 0

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
                    List(viewModel.categories) { category in
                        NavigationLink(destination: CategoryDetailView(category: category, favorites: $viewModel.favorites)) {
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.name)
                                    .font(.headline)
                            }
                            .padding(.vertical)
                        }
                    }
                } else {
                    FavoritesView(favorites: $viewModel.favorites)
                }
            }
            .navigationTitle("Wardrobe")
        }
    }
}

#Preview {
    CategoryView()
}
