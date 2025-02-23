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
    let brand: String
    let dateAdded: Date
}

struct WardrobeCategory: Identifiable {
    let id = UUID()
    let name: String
    var items: [WardrobeItem]
}

struct CategoryView: View {
    @State private var categories: [WardrobeCategory] = [
        WardrobeCategory(name: "Outerwear", items: [
            WardrobeItem(title: "Leather Jacket", color: "Black", type: "Jacket", note: "Casual", imageName: "1", brand: "BrandA", dateAdded: Date()),
            WardrobeItem(title: "Denim Jacket", color: "Blue", type: "Jacket", note: "Everyday wear", imageName: "2", brand: "BrandB", dateAdded: Date().addingTimeInterval(-3600))
        ]),
        WardrobeCategory(name: "Shoes", items: [
            WardrobeItem(title: "Sneakers", color: "White", type: "Casual", note: "Comfortable", imageName: "3", brand: "BrandA", dateAdded: Date().addingTimeInterval(-86400)),
            WardrobeItem(title: "Loafers", color: "Brown", type: "Formal", note: "Work", imageName: "4", brand: "BrandC", dateAdded: Date().addingTimeInterval(-172800))
        ]),
        WardrobeCategory(name: "Accessories", items: [
            WardrobeItem(title: "Sunglasses", color: "Black", type: "Eyewear", note: "Sunny days", imageName: "5", brand: "BrandC", dateAdded: Date().addingTimeInterval(-259200)),
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

        if let color = selectedColor {
            filtered = filtered.filter { $0.color == color }
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
            Button("Refine") {
                showRefineSheet.toggle()
            }
            .padding()

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

struct RefineView: View {
    let items: [WardrobeItem]
    @Binding var selectedSort: SortOption
    @Binding var selectedColor: String?
    @Binding var selectedBrand: String?
    @Binding var selectedType: String?
    
    @Environment(\.dismiss) var dismiss

    // Dynamic filters based on items
    var availableColors: [String] {
        Set(items.map { $0.color }).sorted()
    }
    var availableBrands: [String] {
        Set(items.map { $0.brand }).sorted()
    }
    var availableTypes: [String] {
        Set(items.map { $0.type }).sorted()
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Sort By")) {
                    Picker(selection: $selectedSort, label: EmptyView()) {
                        Text("Recently Added").tag(SortOption.recentlyAdded)
                        Text("A-Z").tag(SortOption.aToZ)
                        Text("Z-A").tag(SortOption.zToA)
                    }
                    .pickerStyle(.inline)
                }

                Section(header: Text("Filter By")) {
                    // Color Filter
                    Picker("Color", selection: $selectedColor) {
                        Text("All").tag(String?.none)
                        ForEach(availableColors, id: \.self) { color in
                            Text(color).tag(String?.some(color))
                        }
                    }
                    .pickerStyle(.menu)

                    // Brand Filter
                    Picker("Brand", selection: $selectedBrand) {
                        Text("All").tag(String?.none)
                        ForEach(availableBrands, id: \.self) { brand in
                            Text(brand).tag(String?.some(brand))
                        }
                    }
                    .pickerStyle(.menu)

                    // Type Filter
                    Picker("Type", selection: $selectedType) {
                        Text("All").tag(String?.none)
                        ForEach(availableTypes, id: \.self) { type in
                            Text(type).tag(String?.some(type))
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("Refine")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        selectedColor = nil
                        selectedBrand = nil
                        selectedType = nil
                        selectedSort = .recentlyAdded
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

enum SortOption {
    case recentlyAdded
    case aToZ
    case zToA
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
                Text("Brand: \(item.brand)").font(.subheadline)
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

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    CategoryView()
}
