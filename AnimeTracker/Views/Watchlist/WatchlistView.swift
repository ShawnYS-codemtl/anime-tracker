//
//  WatchlistView.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-17.
//
import Foundation
import SwiftUI

struct WatchlistView: View {
    @EnvironmentObject var viewModel: AnimeViewModel
    @State private var expandedSections: Set<WatchStatus> = [.watching, .notStarted, .finished]


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(WatchStatus.allCases, id: \.self) { status in
                    let filtered = viewModel.watchlist.filter { $0.watchStatus == status }
                    DisclosureGroup(
                        isExpanded: Binding(
                                get: { expandedSections.contains(status) },
                                set: { isExpanding in
                                    if isExpanding {
                                        expandedSections.insert(status)
                                    } else {
                                        expandedSections.remove(status)
                                    }
                                }
                            ),
                        content: {
                            if filtered.isEmpty {
                                Text("No anime in this section.")
                                    .foregroundColor(.gray)
                                    .padding(.vertical, 8)
                                    .padding(.leading, 8)
                            } else {
                                VStack(spacing: 8) {
                                    ForEach(viewModel.watchlist.filter { $0.watchStatus == status }) { anime in
                                        NavigationLink (destination: AnimeDetailView(anime: anime)) {
                                            WatchlistRow(anime: anime)
                                        }
                                    }
                                }
                                .padding(.leading, 8)
                            }
                        },
                        label: {
                            HStack {
                                        Text(status.rawValue)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                        Spacer()
                                        Text("\(filtered.count)")
                                            .foregroundColor(.secondary)
                                    }
                                    .contentShape(Rectangle()) // makes whole row tappable
                        }
                    )
                    .padding(.horizontal)
                            
                }
            }
            .padding(.top)
        }
        .navigationTitle("Your Watchlist")
    }
}



#Preview {
    MainView()
        .environmentObject(AnimeViewModel())
    
}

