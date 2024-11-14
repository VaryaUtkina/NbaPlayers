//
//  NetworkManager.swift
//  NbaPlayers
//
//  Created by Варвара Уткина on 12.11.2024.
//

import Foundation

enum Link {
    case teams
    case players
    
    var url: NSURL? {
        switch self {
        case .teams: NSURL(string: "https://nba-api-free-data.p.rapidapi.com/nba-team-list")
        case .players: NSURL(string: "https://nba-api-free-data.p.rapidapi.com/nba-player-listing/v1/data?id=22")
        }
    }
}

enum NetworkError: Error {
    case noData
    case decodingError
    case invalidURL
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let headers = [
        "x-rapidapi-key": "8b70de7122mshf7d8da5b54e7c8ap129e91jsn91405a76579c",
        "x-rapidapi-host": "nba-api-free-data.p.rapidapi.com"
    ]
    
    private init() {}
    
    // TODO: - Fetch Players
    func fetchPlayers(with nsUrl: NSURL) {
        let request = NSMutableURLRequest(
            url: nsUrl as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else if let data, let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
        })

        dataTask.resume()
    }
    
    func fetchTeams() async throws -> [Team] {
        guard let nsUrl = Link.teams.url else {
            throw NetworkError.invalidURL
        }
        
        let request = NSMutableURLRequest(
            url: nsUrl as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        let (data, _) = try await URLSession.shared.data(for: request as URLRequest)
        let decoder = JSONDecoder()
        
        do {
            let teamList = try decoder.decode(TeamList.self, from: data)
            return teamList.teams
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func fetchImage(from url: URL?) async throws -> Data {
        guard let url = url else { throw NetworkError.invalidURL }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            throw NetworkError.noData
        }
    }
}
