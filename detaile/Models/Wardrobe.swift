//
//  WardrobeItem.swift
//  detaile
//
//  Created by Denislav Dimitrov on 24.02.25.
//

import Foundation

struct WardrobeItem: Identifiable, Codable {
    let id: UUID
    let title: String
    let colors: [String]
    let type: String
    let note: String
    let imageName: String
    let brand: String
    let dateAdded: Date
}

struct WardrobeCategory: Identifiable, Codable {
    let id: UUID
    let name: String
    let icon: String
    var items: [WardrobeItem]
}

enum SortOption {
    case recentlyAdded
    case aToZ
    case zToA
}

func load<T: Decodable>(_ filename: String) -> T {
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    do {
        let data = try Data(contentsOf: file)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't load or parse \(filename) from main bundle:\n\(error)")
    }
}
