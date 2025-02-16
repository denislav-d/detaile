//
//  Wardrobe.swift
//  detaile
//
//  Created by Denislav Dimitrov on 14.02.25.
//

import SwiftUI

struct WardrobeView: View {
    var selectedTab: Binding<String>
    @State var shouldPresentSheet: Bool = false
    
    
    var body: some View {
        NavigationStack {
//            NavigationLink("Add clothes") {
//                UploadImageView()
//            }
            CategoryView()
            .navigationTitle(Text("Wardrobe"))
        }
    }
}

#Preview {
    WardrobeView(selectedTab: .constant("Wardrobe"))
}
