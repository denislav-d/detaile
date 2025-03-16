//
//  MoodboardView.swift
//  detaile
//
//  Created by Denislav Dimitrov on 28.02.25.
//

import SwiftUI

struct MoodboardView: View {
    var selectedTab: Binding<String>
    
    var body: some View {
        NavigationStack {
            Text("explore daily outfit recommendations")
                .navigationTitle("Moodboard")
        }
    }
}

#Preview {
    MoodboardView(selectedTab: .constant("Moodboard"))
}
