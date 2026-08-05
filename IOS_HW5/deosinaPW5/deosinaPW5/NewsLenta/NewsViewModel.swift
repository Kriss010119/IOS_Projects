//
//  NewsViewModel.swift
//  deosinaPW5
//
//  Created by Kriss Osina on 9.02.2026.
//

import Foundation

class NewsViewModel {
    var articles: [ArticleModel] = []
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func loadNews() {
        print("ViewModel: Start")
        ArticleHelper().fetchNews { [weak self] articles in
            DispatchQueue.main.async {
                if let articles = articles {
                    self?.articles = articles
                    self?.onUpdate?()
                } else {
                    self?.onError?("Failed to load characters")
                }
            }
        }
    }
}
