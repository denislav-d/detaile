//
//  WardrobeItem.swift
//  detaile
//
//  Created by Denislav Dimitrov on 10.02.25.
//

import SwiftUI
import SwiftData

@Model
class WardrobeItem: Identifiable {
    var id: UUID
    var title: String
    var brand: String
    var colors: [String]
    var type: String
    var note: String
    var imageData: Data?
    var dateAdded: Date
    var category: WardrobeCategory?

    init(title: String,
         brand: String,
         colors: [String],
         type: String,
         note: String = "",
         imageData: Data? = nil,
         dateAdded: Date = Date(),
         category: WardrobeCategory? = nil) {
        self.id = UUID()
        self.title = title
        self.brand = brand
        self.colors = colors
        self.type = type
        self.note = note
        self.imageData = imageData
        self.dateAdded = dateAdded
        self.category = category
    }
}

@Model
class WardrobeCategory: Identifiable {
    var id: UUID
    var name: String
 
    var icon: String
    var items: [WardrobeItem]

    init(name: String, icon: String = "folder", items: [WardrobeItem] = []) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.items = items
    }
}

extension WardrobeCategory {
    static var defaultCategories: [WardrobeCategory] {
        [
            WardrobeCategory(name: "Outerwear", icon: "jacket"),
            WardrobeCategory(name: "T-shirts", icon: "tshirt"),
            WardrobeCategory(name: "Shoes", icon: "shoe.2"),
            WardrobeCategory(name: "Accessories", icon: "sunglasses"),
        ]
    }
}
