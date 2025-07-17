//
//  MainView.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-17.
//
import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            NavigationView {
                AnimeDiscover()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }

            NavigationView {
                WatchlistView()
            }
            .tabItem {
                Label("Watchlist", systemImage: "list.star")
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AnimeViewModel())
}

