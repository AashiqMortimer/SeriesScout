//
//  SeriesScoutViewModelTests.swift
//  SeriesScoutTests
//
//  Created by Aashiq Mortimer on 16/02/2024.
//

import XCTest
import Combine
import SwiftUI
@testable import SeriesScout

final class SeriesScoutViewModelTests: XCTestCase {

    var viewModel: SeriesScoutViewModel!
    private var cancellables: Set<AnyCancellable>! = []

    override func setUpWithError() throws {
        super.setUp()
        let mockedNetwork = MockSeriesScoutNetworkService(resource: "UtellySampleResponse")
        viewModel = SeriesScoutViewModel(networkService: mockedNetwork)
        viewModel.fetchUtellyData()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testFetchUtellyDataSuccess() throws {
        let expectation = self.expectation(description: "Waiting for data fetch")
        
        viewModel
            .$utellyData
            .dropFirst()
            .sink { value in
                XCTAssertNotNil(value?.results)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testViewModelReturnsSeriesName() throws {
        let expectation = self.expectation(description: "Waiting for data fetch")
        
        viewModel
            .$seriesName
            .dropFirst()
            .sink { name in
                XCTAssertEqual(name.description, "BoJack Horseman")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testViewModelReturnsStreamingWebsite() throws {
        let expectation = self.expectation(description: "Waiting for data fetch")
        
        viewModel
            .$streamingWebsite
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value.description, "Netflix")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testViewModelReturnsSeriesPicture() throws {
        let expectation = self.expectation(description: "Waiting for data fetch")
        
        viewModel
            .$seriesPicture
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value!.description, "https://utellyassets9-1.imgix.net/api/Images/4e4d50a0040fd4500193202edbafce6a/Redirect?fit=crop&auto=compress&crop=faces,top")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testViewModelReturnsStreamingWebsiteIcon() throws {
        let expectation = self.expectation(description: "Waiting for data fetch")
        
        viewModel
            .$streamingWebsiteIcon
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value.description, "https://utellyassets7.imgix.net/locations_icons/utelly/black_new/NetflixIVAGB.png?w=92&auto=compress&app_version=23f8e481-9672-42ce-b1c8-b950bb12d45a_e12122021-01-29")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testErrorMessageReturnsNil() throws {
        let expectation = self.expectation(description: "Waiting for data fetch")
        
        viewModel
            .$errorMessage
            .sink { value in
                XCTAssertNil(value?.description)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.5)
        
        //TODO: Test case for when error is expected
    }
    
    func testCorrectBrandColor() throws {
        
        let netflix = viewModel.returnBrandColor(streamingWebsite: "Netflix")
        let amazon = viewModel.returnBrandColor(streamingWebsite: "Amazon")
        let iTunes = viewModel.returnBrandColor(streamingWebsite: "iTunes")
        let youtube = viewModel.returnBrandColor(streamingWebsite: "YouTube")
        let disney = viewModel.returnBrandColor(streamingWebsite: "Disney")
        let hulu = viewModel.returnBrandColor(streamingWebsite: "Hulu")
        let google = viewModel.returnBrandColor(streamingWebsite: "Google")
        
        XCTAssertEqual(netflix, Color.red)
        XCTAssertEqual(amazon, Color.blue)
        XCTAssertEqual(iTunes, Color.white)
        XCTAssertEqual(disney, Color.blue)
        XCTAssertEqual(hulu, Color.green)
        XCTAssertEqual(google, Color.orange)
        XCTAssertEqual(youtube, Color.red)
    }
}

// Best off creating a set of unit tests for my "repository"

// Still worth writing a mock unit test for the repository so that I can be more thorough with testing certain use cases such as particular errors like dropping internet connection
