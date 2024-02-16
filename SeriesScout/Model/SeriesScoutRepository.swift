//
//  SeriesScoutRepository.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/02/2024.
//

import Foundation

class SeriesScoutRepository {
    private let session: URLSession
    private let baseURL = URL(string: "https://utelly-tv-shows-and-movies-availability-v1.p.rapidapi.com")!
    private let apiKey = "855daeef13msh6294ff64512c2dcp1a86dfjsn60afe6ddc0dd"
    private let host = "utelly-tv-shows-and-movies-availability-v1.p.rapidapi.com"
    
    init(session: URLSession = .shared) {
            self.session = session
        }
    
    
    func fetchUtellyData(completion: @escaping (Result<UtellyModel, NetworkError>) -> Void) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = "/lookup"
        urlComponents?.queryItems = [
            URLQueryItem(name: "term", value: "bojack"),
            URLQueryItem(name: "country", value: "uk")
        ]
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue(host, forHTTPHeaderField: "X-RapidAPI-Host")
        
        let task = session.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            do {
                let utelly = try JSONDecoder().decode(UtellyModel.self, from: data)
                completion(.success(utelly))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        task.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
}
