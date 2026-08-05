//
//  ArticleHelper.swift
//  deosinaPW5
//
//  Created by Kriss Osina on 9.02.2026.
//

import Foundation

class ArticleHelper {
    private let decoder = JSONDecoder()
    private let baseURL = "https://api.disneyapi.dev/character"
    
    func fetchNews(completion: @escaping ([ArticleModel]?) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    print("HTTP Error: \(httpResponse.statusCode)")
                    completion(nil)
                    return
                }
            }
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON (first 100 chars): \(String(jsonString.prefix(100)))...")
            }
            do {
                let response = try self.decoder.decode(DisneyAPIResponse.self, from: data)
                completion(response.data)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
}
