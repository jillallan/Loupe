//
//  LoupeApp.swift
//  Loupe
//
//  Created by Jill Allan on 18/07/2025.
//

import SwiftUI
import SwiftData

@main
struct LoupeApp: App {
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
            PhotoView()
        }
        .modelContainer(sharedModelContainer)
    }
}
