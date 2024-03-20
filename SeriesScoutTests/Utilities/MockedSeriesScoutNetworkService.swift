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
    var utellyDataToReturn: UtellyModel?

    func fetchUtellyData(searchTerm: String, completion: @escaping (Result<SeriesScout.UtellyModel, SeriesScout.NetworkError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.invalidURL))
        } else {
            completion(.success(utellyDataToReturn!))
        }
    }
}
