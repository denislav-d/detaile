//
//  ItemDetailView.swift
//  detaile
//
//  Created by Denislav Dimitrov on 24.02.25.
//

import SwiftUI

struct ItemDetailView: View {
    let item: WardrobeItem
    @Binding var favorites: [WardrobeItem]
    
    var isFavorited: Bool {
        favorites.contains { $0.id == item.id }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .shadow(radius: 5)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text(item.title)
                        .font(.title)
                        .bold()
                    
                    Text(item.brand)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("\(item.colors.joined(separator: "• ")) • \(item.type)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Divider()
                    
                    Text(item.note)
                        .font(.body)
                        .italic()
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Button(action: {
                        if isFavorited {
                            favorites.removeAll { $0.id == item.id }
                        } else {
                            favorites.append(item)
                        }
                    }) {
                        HStack {
                            Image(systemName: isFavorited ? "heart.fill" : "heart")
                            Text(isFavorited ? "Remove from Favorites" : "Add to Favorites")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .foregroundColor(.blue)
                }
                .padding()
            }
            .padding()
        }
    }
}

//#Preview {
//    ItemDetailView()
//}
