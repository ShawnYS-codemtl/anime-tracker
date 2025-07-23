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
                WatchlistView()
            }
            .tabItem {
                Label("Watchlist", systemImage: "list.star")
            }
            
            NavigationView {
                AnimeDiscover()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            
            NavigationView {
                GenreSearchView()
            }
            .tabItem {
                Label("Search by Genre", systemImage: "book.pages")
            }
            
            
            
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AnimeViewModel())
}

