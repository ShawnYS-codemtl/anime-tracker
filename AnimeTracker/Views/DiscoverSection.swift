//
//  DiscoverSection.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-20.
//

import SwiftUI
import Kingfisher

struct DiscoverSection: View {
    let title: String
    let animeList: [Anime]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .bold()
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    if animeList.isEmpty {
                        Text("No anime to show")
                            .foregroundColor(.gray)
                            .padding()
                    } else{
                        ForEach(animeList) { anime in
                            NavigationLink(destination: AnimeDetailView(anime: anime)) {
                                VStack(spacing: 8) {
                                    KFImage(URL(string: anime.imageUrl))
                                        .resizable()
                                        .placeholder { ProgressView() }
                                        .fade(duration: 0.25)
                                        .frame(width: 120, height: 180)
                                        .cornerRadius(12)
                                    
                                    Text(anime.title)
                                        .font(.system(size: 12, weight: .heavy, design: .rounded))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .frame(width: 120)
                                        
                                }
                                .frame(width: 120, height: 220, alignment: .top)
                            }
                        }
                        
                    }
                    
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AnimeViewModel())
}
