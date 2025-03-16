//
//  WardrobeItemCard.swift
//  detaile
//
//  Created by Denislav Dimitrov on 24.02.25.
//

import SwiftUI
//
//struct ItemCard: View {
//    let item: WardrobeItem
//    @Binding var favorites: [WardrobeItem]
//    @State private var showDetail = false
//
//    var body: some View {
//        Button(action: { showDetail.toggle() }) {
//            Image(item.imageName)
//                .resizable()
//                .scaledToFill()
//                .frame(height: 150)
//                .clipShape(RoundedRectangle(cornerRadius: 15))
//        }
//        .sheet(isPresented: $showDetail) {
//            ItemDetailView(item: item, favorites: $favorites)
//            .presentationDragIndicator(.visible)
//        }
//    }
//}

struct WardrobeItemCard: View {
    let item: WardrobeItem
    
    var body: some View {
        VStack {
            if let data = item.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                                  .scaledToFill()
                                    .frame(height: 150)
                                   .clipShape(RoundedRectangle(cornerRadius: 15))
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
            }
        }
    }
}

//
//#Preview {
//    ItemCard(item: <#WardrobeItem#>, favorites: <#Binding<[WardrobeItem]>#>)
//}
