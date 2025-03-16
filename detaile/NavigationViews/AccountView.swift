//
//  AccountView.swift
//  detaile
//
//  Created by Denislav Dimitrov on 16.02.25.
//

import SwiftUI

struct AccountView: View {
    var selectedTab: Binding<String>
    
    var body: some View {
        NavigationStack {
            Text("my account")
                .navigationTitle("Account")
        }
    }
}

#Preview {
    AccountView(selectedTab: .constant("Account"))
}
