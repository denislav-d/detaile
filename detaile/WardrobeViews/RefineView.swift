//
//  RefineView.swift
//  detaile
//
//  Created by Denislav Dimitrov on 24.02.25.
//

import SwiftUI

struct RefineView: View {
    let items: [WardrobeItem]
    @Binding var selectedSort: SortOption
    @Binding var selectedColor: String?
    @Binding var selectedBrand: String?
    @Binding var selectedType: String?
    
    @Environment(\.dismiss) var dismiss

    // Dynamic filters based on items
    var availableColors: [String] {
        Set(items.flatMap { $0.colors }).sorted()
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

//#Preview {
//    RefineView()
//}
