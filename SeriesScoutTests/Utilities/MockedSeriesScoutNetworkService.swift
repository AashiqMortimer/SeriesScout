//
//  MockedSeriesScoutRepository.swift
//  SeriesScoutTests
//
//  Created by Aashiq Mortimer on 16/02/2024.
//

import Foundation
@testable import SeriesScout

class MockSeriesScoutNetworkService: SeriesScoutNetworkServiceRepresentable {
    var shouldReturnError = false

    func fetchUtellyData(searchTerm: String, completion: @escaping (Result<SeriesScout.UtellyModel, SeriesScout.NetworkError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.invalidURL))
        } else {
            let decoder = JSONDecoder()
            
            let bundle = Bundle(for: type(of: self))
            
            guard let filePath = bundle.path(forResource: "UtellySampleResponse", ofType: "json") else {
                fatalError("UtellySampleResponse.json not found")
            }
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                try completion(.success(decoder.decode(UtellyModel.self, from: data)))
            } catch {
                print("❌: \(error.localizedDescription)")
                fatalError("Failed to decode JSON.")
            }
            
            
        }
    }
}
