//
//  CoachMarkViewTests.swift
//  SeriesScoutTests
//
//  Created by Aashiq Mortimer on 11/05/2024.
//

import SnapshotTesting
import XCTest
import SwiftUI
@testable import SeriesScout

final class CoachMarkViewTests: XCTestCase {
    
    func testCoachMarkView() {
        let view = CoachMarkView(title: "Title", message: "This is a coach mark", buttonText: "Got it", userDefaults: CoachMarksUserDefaults(), key: "testKey")
        
        assertSnapshot(of: view, as: .image)
    }
}
