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
    
    func fetchPlayers(with url: NSURL, completion: @escaping(Result<[Team],NetworkError>) -> Void) {
        let headers = [
            "x-rapidapi-key": "8b70de7122mshf7d8da5b54e7c8ap129e91jsn91405a76579c",
            "x-rapidapi-host": "sports-information.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(
            url: url as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let decoder = JSONDecoder()
                let sports = try decoder.decode(NbaTeam.self, from: data)
                var teams: [Team] = []
                for sport in sports.sports {
                    for league in sport.leagues {
                        for teamList in league.teams {
                            teams.append(teamList.team)
                        }
                    }
                }
                completion(.success(teams))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
