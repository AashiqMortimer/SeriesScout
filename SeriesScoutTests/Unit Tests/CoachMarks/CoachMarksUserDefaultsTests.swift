//
//  CoachMarksUserDefaultsTests.swift
//  SeriesScoutTests
//
//  Created by Aashiq Mortimer on 11/05/2024.
//

import XCTest
@testable import SeriesScout

final class CoachMarksUserDefaultsTests: XCTestCase {
    var coachMarksUserDefaults: CoachMarksUserDefaults!
    var userDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "TestSuite")
        userDefaults.removePersistentDomain(forName: "TestSuite")
        coachMarksUserDefaults = CoachMarksUserDefaults(defaults: userDefaults)
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "TestSuite")
        userDefaults = nil
        coachMarksUserDefaults = nil
        super.tearDown()
    }
    
    func testInitialisedValues() {
        let interactionKey = "test_interactionFlag"
        let viewKey = "test_viewCount"
        coachMarksUserDefaults.initialiseValues(interactionKey: interactionKey, viewKey: viewKey)
        XCTAssertFalse(coachMarksUserDefaults.interactionOccurred(forKey: interactionKey))
        XCTAssertEqual(coachMarksUserDefaults.viewCount(forKey: viewKey), 0)
        XCTAssertNil(coachMarksUserDefaults.coachMarkHeight)
    }
    
    func testIncrementViewCount() {
        let baseKey = "test"
        coachMarksUserDefaults.incrementViewCount(forKey: baseKey)
        XCTAssertEqual(coachMarksUserDefaults.viewCount(forKey: baseKey + "_viewCount"), 1)
        XCTAssertEqual(userDefaults.dictionary(forKey: "coachMarks")?.keys.first, "test_viewCount")
    }
    
    func testSetInteraction() {
        let baseKey = "test"
        coachMarksUserDefaults.setInteraction(forKey: baseKey)
        XCTAssertTrue(coachMarksUserDefaults.interactionOccurred(forKey: baseKey + "_interactionFlag"))
        XCTAssertEqual(userDefaults.dictionary(forKey: "coachMarks")?.keys.first, "test_interactionFlag")
    }
    
    func testResetCoachMarks() {
        let baseKey = "test"
        coachMarksUserDefaults.incrementViewCount(forKey: baseKey)
        coachMarksUserDefaults.setInteraction(forKey: baseKey)
        coachMarksUserDefaults.resetCoachMarks()
        XCTAssertEqual(coachMarksUserDefaults.viewCount(forKey: baseKey + "_viewCount"), 0)
        XCTAssertFalse(coachMarksUserDefaults.interactionOccurred(forKey: baseKey + "_interactionFlag"))
    }
    
    func testWrappedValueReturnsFalseInitially() {
        let coachMark = CoachMark(key: "myKey", threshold: 2, userDefaults: coachMarksUserDefaults)
        XCTAssertFalse(coachMark.wrappedValue)
    }
    
    func testWrappedValueReturnsTrueAfterThresholdMet() {
        let coachMark = CoachMark(key: "myKey", threshold: 2, userDefaults: coachMarksUserDefaults)
        for _ in 0..<2 { // Increment view count twice
            coachMark.projectedValue.incrementViewCount(forKey: "myKey")
        }
        XCTAssertTrue(coachMark.wrappedValue)
    }
    
    func testWrappedValueHidesAfterInteraction() {
        let coachMark = CoachMark(key: "myKey", threshold: 2, userDefaults: coachMarksUserDefaults)
        coachMark.projectedValue.setInteraction(forKey: "myKey")
        XCTAssertFalse(coachMark.wrappedValue)
    }
}
