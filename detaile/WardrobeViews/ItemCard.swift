//
//  ItemCard.swift
//  detaile
//
//  Created by Denislav Dimitrov on 24.02.25.
//

import SwiftUI

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
            .presentationDragIndicator(.visible)
        }
    }
}

//
//#Preview {
//    ItemCard(item: <#WardrobeItem#>, favorites: <#Binding<[WardrobeItem]>#>)
//}
