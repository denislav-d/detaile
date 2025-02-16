//
//  CategoryView.swift
//  detaile
//
//  Created by Denislav Dimitrov on 16.02.25.
//

import SwiftUI

struct WardrobeItem: Identifiable {
    let id = UUID()
    let title: String
    let color: String
    let type: String
    let note: String
    let imageName: String
    var isFavorite: Bool = false
}

struct WardrobeCategory: Identifiable {
    let id = UUID()
    let name: String
    var items: [WardrobeItem]
}

struct CategoryView: View {
    @State private var categories: [WardrobeCategory] = [
        WardrobeCategory(name: "Outerwear", items: [
            WardrobeItem(title: "Leather Jacket", color: "Black", type: "Jacket", note: "Casual", imageName: "3"),
            WardrobeItem(title: "Sweater", color: "White", type: "Sweater", note: "Everyday wear", imageName: "4")
        ]),
        WardrobeCategory(name: "T-shirts", items: [
            WardrobeItem(title: "T-shirt", color: "Brown", type: "Casual", note: "Comfortable", imageName: "5"),
        ]),
        WardrobeCategory(name: "Bags", items: [
            WardrobeItem(title: "Bows bag", color: "White", type: "Bags", note: "Fancy", imageName: "2"),
        ])
    ]
    
    @State private var favorites: [WardrobeItem] = []
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
                    List(categories) { category in
                        NavigationLink(destination: CategoryDetailView(category: category, favorites: $favorites)) {
                            Text(category.name)
                                .font(.headline)
                                .padding()
                        }
                    }
                } else {
                    FavoritesView(favorites: $favorites)
                }
            }
            .navigationTitle("Wardrobe")
        }
    }
}

struct CategoryDetailView: View {
    let category: WardrobeCategory
    @Binding var favorites: [WardrobeItem]
    @State private var selectedFilter: String = "A-Z"

    let filters = ["A-Z", "Z-A", "Color"]

    var sortedItems: [WardrobeItem] {
        switch selectedFilter {
        case "A-Z":
            return category.items.sorted { $0.title < $1.title }
        case "Z-A":
            return category.items.sorted { $0.title > $1.title }
        case "Color":
            return category.items.sorted { $0.color < $1.color }
        default:
            return category.items
        }
    }

    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)

    var body: some View {
        VStack {
            Picker("Filter", selection: $selectedFilter) {
                ForEach(filters, id: \.self) { filter in
                    Text(filter).tag(filter)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(sortedItems) { item in
                        ItemCard(item: item, favorites: $favorites)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(category.name)
    }
}

struct ItemCard: View {
    let item: WardrobeItem
    @Binding var favorites: [WardrobeItem]
    @State private var showDetail = false

    var body: some View {
        Button(action: { showDetail.toggle() }) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .sheet(isPresented: $showDetail) {
            ItemDetailView(item: item, favorites: $favorites)
        }
    }
}

struct ItemDetailView: View {
    let item: WardrobeItem
    @Binding var favorites: [WardrobeItem]
    
    var isFavorited: Bool {
        favorites.contains { $0.id == item.id }
    }

    var body: some View {
        VStack {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 300)

            VStack(alignment: .leading, spacing: 10) {
                Text(item.title).font(.title).bold()
                Text("Color: \(item.color)").font(.headline)
                Text("Type: \(item.type)").font(.subheadline)
                Text(item.note).italic().font(.caption)

                Button(action: {
                    if isFavorited {
                        favorites.removeAll { $0.id == item.id }
                    } else {
                        favorites.append(item)
                    }
                }) {
                    HStack {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                        Text(isFavorited ? "Remove from Favorites" : "Add to Favorites")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 10)
            }
            .padding()
        }
    }
}

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
                            Image(item.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
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
    CategoryView()
}
