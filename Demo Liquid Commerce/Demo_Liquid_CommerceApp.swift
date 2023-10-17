//
//  Demo_Liquid_CommerceApp.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 17/10/2023.
//

import SwiftUI
import SwiftData

@main
struct Demo_Liquid_CommerceApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
