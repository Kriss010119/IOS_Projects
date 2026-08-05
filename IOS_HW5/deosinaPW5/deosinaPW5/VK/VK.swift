//
//  VK.swift
//  deosinaPW5
//
//  Created by Kriss Osina on 9.02.2026.
//

import UIKit

class VK {
    static let shared = VK()
    private init() {}
    
    private var isVKAppInstalled: Bool {
        let vkURL = URL(string: "vk://")!
        return UIApplication.shared.canOpenURL(vkURL)
    }
    
    func shareToVK(article: ArticleModel, from viewController: UIViewController) {
        let shareText = createShareText(for: article)
        
        if isVKAppInstalled {
            var urlComponents = URLComponents(string: "vk://share")!
            urlComponents.queryItems = [
                URLQueryItem(name: "message", value: shareText),
                URLQueryItem(name: "title", value: article.name)
            ]
            
            if let url = urlComponents.url {
                UIApplication.shared.open(url)
            }
        } else {
            shareViaSystemSheet(article: article, from: viewController)
        }
    }
    
    func shareViaSystemSheet(article: ArticleModel, from viewController: UIViewController) {
        let shareText = createShareText(for: article)
        let items: [Any] = [shareText]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        viewController.present(activityVC, animated: true)
    }
    
    private func createShareText(for article: ArticleModel) -> String {
        var text = "Персонаж Disney: \(article.name)\n\n"
        if !article.films.isEmpty {
            let films = article.films.prefix(3).joined(separator: ", ")
            text += "Фильмы: \(films)\n"
        }
        if !article.tvShows.isEmpty {
            let shows = article.tvShows.prefix(3).joined(separator: ", ")
            text += "Шоу: \(shows)\n"
        }
        if let url = article.url {
            text += "\nПодробнее: \(url.absoluteString)"
        }
        text += "\n\n#DisneyCharacters"
        return text
    }
}
