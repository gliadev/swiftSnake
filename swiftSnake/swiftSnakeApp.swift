//
//  swiftSnakeApp.swift
//  swiftSnake
//
//  Created by Adolfo on 18/3/25.
//

import SwiftUI
import SwiftData

@main
struct swiftSnakeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ScoreRecord.self,
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
            WelcomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
