//
//  Favorites.swift
//  detaile
//
//  Created by Denislav Dimitrov on 24.02.25.
//

import SwiftUI

struct FavoritesView: View {
    @Binding var favorites: [WardrobeItem]

    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)

    var body: some View {
        VStack {
            if favorites.isEmpty {
                Text("No favorites yet")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(favorites) { item in
                            NavigationLink(destination: WardrobeItemDetailView(item: item, favorites: $favorites)) {
                                WardrobeItemCard(item: item)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Favorites")
    }
}

#Preview {
    FavoritesView(favorites: .constant([]))
}
