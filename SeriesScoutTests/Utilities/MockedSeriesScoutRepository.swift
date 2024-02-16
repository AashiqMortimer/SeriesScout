//
//  MockedSeriesScoutRepository.swift
//  SeriesScoutTests
//
//  Created by Aashiq Mortimer on 16/02/2024.
//

import Foundation
@testable import SeriesScout

class MockedSeriesScoutRepository {
    private let session: URLSession
    private let baseURL = URL(string: "https://utelly-tv-shows-and-movies-availability-v1.p.rapidapi.com")!
    private let apiKey = "855daeef13msh6294ff64512c2dcp1a86dfjsn60afe6ddc0dd"
    private let host = "utelly-tv-shows-and-movies-availability-v1.p.rapidapi.com"
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    
    func fetchUtellyData(completion: @escaping (Result<UtellyModel, NetworkError>) -> Void) {
        guard let url = mockDataURL() else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, _, error in
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
    
    private func mockDataURL() -> URL? {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.url(forResource: "UtellySampleResponse", withExtension: "json") else {
            return nil
        }
        return path
    }
}

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
}
