//
//  DailyDetaileView.swift
//  detaile
//
//  Created by Denislav Dimitrov on 14.02.25.
//

import SwiftUI

struct DailyDetaileView: View {
    var selectedTab: Binding<String>
    
    var body: some View {
        NavigationStack {
            Text("explore daily outfit recommendations")
            
                .navigationTitle("detaile")
        }
    }
}

//#Preview {
//    DailyDetaileView()
//}
