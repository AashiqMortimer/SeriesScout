//
//  SeriesScoutRepositoryTests.swift
//  SeriesScoutTests
//
//  Created by Aashiq Mortimer on 15/02/2024.
//

import XCTest
@testable import SeriesScout

class SeriesScoutRepositoryTests: XCTestCase, MockedRequest {
    
    func testFetchUtellyDataSuccess() {
        // Given
        let repository = MockedSeriesScoutRepository()
        
        // When
        repository.fetchUtellyData { result in
            // Then
            switch result {
            case .success(let utellyModel):
                XCTAssertNotNil(utellyModel)
            case .failure(let error):
                XCTFail("Expected success, but got failure: \(error)")
            }
        }
    }
    
    func testFetchUtellyDataFailure() {
        // Given
        let repository = SeriesScoutRepository()
        
        // When
        repository.fetchUtellyData { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should not be nil")
            }
        }
    }
}
