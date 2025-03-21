//
//  detaileApp.swift
//  detaile
//
//  Created by Denislav Dimitrov on 10.02.25.
//

import SwiftUI
import SwiftData

@main
struct detaileApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            WardrobeItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
