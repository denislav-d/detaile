//
//  Wardrobe.swift
//  detaile
//
//  Created by Denislav Dimitrov on 14.02.25.
//

import SwiftUI

struct WardrobeView: View {
    var selectedTab: Binding<String>
    
    var body: some View {
        NavigationStack {
            Text("Wardrobe")
                .navigationTitle(Text("detaile"))
        }
    }
}

//#Preview {
//    WardrobeView(selectedTab: Binding<"Wardrobe">)
//}
