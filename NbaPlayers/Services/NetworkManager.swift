//
//  NetworkManager.swift
//  NbaPlayers
//
//  Created by Варвара Уткина on 12.11.2024.
//

import Foundation

enum NetworkError: Error {
    case noData
    case decodingError
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch(from nsUrl: NSURL, completion: @escaping(Result<[Team], NetworkError>) -> Void) {
        let headers = [
            "x-rapidapi-key": "8b70de7122mshf7d8da5b54e7c8ap129e91jsn91405a76579c",
            "x-rapidapi-host": "nba-api-free-data.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(
            url: nsUrl as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request as URLRequest){ data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let teams = try decoder.decode(TeamList.self, from: data)
                completion(.success(teams.teams))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
}
