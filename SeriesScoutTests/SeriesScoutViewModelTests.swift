//
//  SeriesScoutViewModelTests.swift
//  SeriesScoutTests
//
//  Created by Aashiq Mortimer on 16/02/2024.
//

import XCTest
@testable import SeriesScout

final class SeriesScoutViewModelTests: XCTestCase {

    var viewModel: SeriesScoutViewModel!
    var mockRepository: MockSeriesScoutRepository!

    override func setUpWithError() throws {
        super.setUp()
        mockRepository = MockSeriesScoutRepository()
        viewModel = SeriesScoutViewModel(repository: mockRepository)
        
        let bundle = Bundle(for: type(of: self))
        guard let filePath = bundle.path(forResource: "UtellySampleResponse", ofType: "json") else {
            fatalError("UtellySampleResponse.json not found")
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
        
        mockRepository.utellyDataToReturn = try JSONDecoder().decode(UtellyModel.self, from: data)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }

    func testFetchUtellyDataSuccess() throws {
        // James: Can do self.expectation instead of line 38 (gets linked to the test case)
        let expectation = XCTestExpectation(description: "Waiting for data fetch")
        viewModel.fetchUtellyData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.seriesName, "BoJack Horseman")
        XCTAssertEqual(viewModel.streamingWebsite, "Netflix")
        XCTAssertEqual(viewModel.seriesPicture, "https://utellyassets9-1.imgix.net/api/Images/4e4d50a0040fd4500193202edbafce6a/Redirect?fit=crop&auto=compress&crop=faces,top")
        XCTAssertEqual(viewModel.streamingWebsiteIcon, "https://utellyassets7.imgix.net/locations_icons/utelly/black_new/NetflixIVAGB.png?w=92&auto=compress&app_version=23f8e481-9672-42ce-b1c8-b950bb12d45a_e12122021-01-29")
    }
}
