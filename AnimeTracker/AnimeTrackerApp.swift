//
//  AnimeTrackerApp.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-15.
//

import SwiftUI

@main
struct AnimeTrackerApp: App {
    @StateObject var viewModel = AnimeViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewModel)
        }
    }
}
