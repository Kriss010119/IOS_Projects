//
//  ArticleModel.swift
//  deosinaPW5
//
//  Created by Kriss Osina on 9.02.2026.
//

import Foundation

struct DisneyAPIResponse: Decodable {
    let data: [ArticleModel]
}

struct ArticleModel: Decodable {
    let _id: Int
    let films: [String]
    let shortFilms: [String]
    let tvShows: [String]
    let videoGames: [String]
    let parkAttractions: [String]
    let allies: [String]
    let enemies: [String]
    let name: String
    let imageUrl: URL?
    let url: URL?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        _id = try container.decode(Int.self, forKey: ._id)
        films = try container.decode([String].self, forKey: .films)
        shortFilms = try container.decode([String].self, forKey: .shortFilms)
        tvShows = try container.decode([String].self, forKey: .tvShows)
        videoGames = try container.decode([String].self, forKey: .videoGames)
        parkAttractions = try container.decode([String].self, forKey: .parkAttractions)
        allies = try container.decode([String].self, forKey: .allies)
        enemies = try container.decode([String].self, forKey: .enemies)
        name = try container.decode(String.self, forKey: .name)
        
        if let imageUrlString = try? container.decode(String.self, forKey: .imageUrl),
           let url = URL(string: imageUrlString) {
            imageUrl = url
        } else {
            imageUrl = nil
        }
        
        if let urlString = try? container.decode(String.self, forKey: .url),
           let url = URL(string: urlString) {
            self.url = url
        } else {
            url = nil
        }
    }
    
    var title: String { name }
    var description: String {
        var desc = ""
        if !films.isEmpty {
            desc += "Films: \(films.joined(separator: ", "))\n"
        }
        if !tvShows.isEmpty {
            desc += "TV Shows: \(tvShows.joined(separator: ", "))\n"
        }
        if !videoGames.isEmpty {
            desc += "Video Games: \(videoGames.joined(separator: ", "))"
        }
        return desc.isEmpty ? "No media info available" : desc
    }
    
    var urlToImage: URL? { imageUrl }
    enum CodingKeys: String, CodingKey {
        case _id, films, shortFilms, tvShows, videoGames, parkAttractions
        case allies, enemies, name, imageUrl, url
    }
}
