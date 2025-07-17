//
//  AnimeAPI.swift
//  AnimeTracker
//
//  Created by Shawn Yat Sin on 2025-07-15.
//

import Foundation

struct AniListResponse: Decodable {
    struct Media: Decodable {
        var id: Int
        var title: Title
        var coverImage: CoverImage
        let description: String?
        let episodes: Int?
        let averageScore: Int?
        let genres: [String]
        let studios: Studios
        let seasonYear: Int?
        let trailer: Trailer?

        struct Title: Decodable {
            let romaji: String
        }

        struct CoverImage: Decodable {
            let large: String
        }
        struct Studios: Decodable {
                let nodes: [StudioNode]
                struct StudioNode: Decodable {
                    let name: String
                }
        }
        struct Trailer: Decodable {
                let id: String
                let site: String
        }
    }

    struct DataContainer: Decodable {
        let Page: Page

        struct Page: Decodable {
            let media: [Media]
        }
    }

    let data: DataContainer
}

class AnimeAPI {
    static func searchAnime(query: String, completion: @escaping ([Anime]) -> Void) {
        let url = URL(string: "https://graphql.anilist.co")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let graphQLQuery = """
        query ($search: String) {
          Page(perPage: 10) {
            media(search: $search, type: ANIME) {
              id
              title {
                romaji
              }
              coverImage {
                large
              }
              episodes
              averageScore
              genres
              studios(isMain: true) {
                nodes {
                  name
                }
              }
              seasonYear
              trailer {
                id
                site
              }
              description(asHtml: false)
            }
          }
        }
        """

        let json: [String: Any] = [
            "query": graphQLQuery,
            "variables": ["search": query]
        ]

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("API error:", error ?? "")
                completion([])
                return
            }

            do {
                let decoded = try JSONDecoder().decode(AniListResponse.self, from: data)
                let results = decoded.data.Page.media.map { media in
                    let studioName = media.studios.nodes.first?.name ?? "Unknown"
                    
                    var trailerLink: String? = nil
                    if let trailer = media.trailer, trailer.site == "youtube" {
                        trailerLink = "https://youtube.com/watch?v=\(trailer.id)"
                    }

                    return Anime(
                        id: media.id,
                        title: media.title.romaji,
                        imageUrl: media.coverImage.large,
                        description: media.description ?? "No description available.",
                        episodes: media.episodes,
                        averageScore: media.averageScore,
                        genres: media.genres,
                        studio: studioName,
                        seasonYear: media.seasonYear,
                        trailerUrl: trailerLink
                    )
                }
                completion(results)
            } catch {
                print("Decoding error:", error)
                completion([])
            }
        }.resume()
    }
}

