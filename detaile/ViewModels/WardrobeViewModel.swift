//
//  WardrobeViewModel.swift
//  detaile
//
//  Created by Denislav Dimitrov on 24.02.25.
//

import SwiftUI

class WardrobeViewModel: ObservableObject {
    @Published var categories: [WardrobeCategory] = load("wardrobe_data.json")
    @Published var favorites: [WardrobeItem] = []

    init() {
        loadCategories()
    }

    func loadCategories() {
        if let url = Bundle.main.url(forResource: "Wardrobe", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decodedData = try? JSONDecoder().decode([WardrobeCategory].self, from: data) {
            self.categories = decodedData
        }
    }

    func toggleFavorite(_ item: WardrobeItem) {
        if let index = favorites.firstIndex(where: { $0.id == item.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(item)
        }
    }
}
