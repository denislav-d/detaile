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
            NavigationLink("Add clothes") {
                UploadImageView()
            } .navigationTitle(Text("wardrobe"))
               
            
//            Button("Present Sheet") {
//                shouldPresentSheet.toggle()
//            }
//            .sheet(isPresented: $shouldPresentSheet) {
//                print("Sheet dismissed!")
//            } content: {
//                UploadImageView()
//                    .presentationDetents([.medium, .large])
//                    .presentationDragIndicator(.visible)
//            }
        }
    }
}

//#Preview {
//    WardrobeView(selectedTab: Binding<"Wardrobe">)
//}
