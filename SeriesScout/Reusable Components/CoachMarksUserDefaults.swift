//
//  CoachMarksUserDefaults.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/04/2024.
//

import Foundation
import SwiftUI

//class CoachMarksUserDefaults: ObservableObject {
//    
//    //TODO: Try this as a property wrapper again. (Dynamic Property Wrapper)
//    // This should negate the ViewModel: You would just have this that has the viewCount, interactionOccurred, and shouldShow
//    // WrappedValue and ProjectedValue.
//    // Wrapped is a boolean to say if it should show the coach marks or not.
//    // ProjectedValue would be my userdefaults properties that I have here as a class.
//    // Would keep this class, alongside the property wrapper.
//    
//    
//    // Ideal implementation within the View:
//    // Initialise it: @Coachmark(key: "EAT-Shortlist, threshold: 3) var showShortlistCoachMark
//    // $showShortlistCoachMark.incrementViewCounter()
//    // $showShortlistCoachMark.markInteractionOcurred()
//    
//    private let viewKey: String
//    private let interactionKey: String
//    
//    @Published var interactionOccurred: Bool = false
//    @Published var viewCount: Int = 0
//    
//    private var defaults: UserDefaults
//    
//    init(viewKey: String, interactionKey: String, defaults: UserDefaults = .standard) {
//        self.viewKey = viewKey
//        self.interactionKey = interactionKey
//        self.defaults = defaults
//        
//        if let coachMarks = defaults.dictionary(forKey: "coachMarks") {
//            interactionOccurred = coachMarks[interactionKey] as? Bool ?? false
//            viewCount = coachMarks[viewKey] as? Int ?? 0
//        }
//    }
//    
//    private func updateDefaults() {
//        var coachMarks = defaults.dictionary(forKey: "coachMarks") ?? [:]
//        coachMarks[viewKey] = viewCount
//        coachMarks[interactionKey] = interactionOccurred
//        defaults.set(coachMarks, forKey: "coachMarks")
//    }
//    
//    func incrementViewCount() {
//        viewCount += 1
//        updateDefaults()
//    }
//    
//    func setInteraction() {
//        guard !interactionOccurred else { return }
//        interactionOccurred = true
//        updateDefaults()
//    }
//    
//    //TODO: Delete later, this is just for testing purposes:
//    func resetCoachMarks() {
//        viewCount = 0
//        interactionOccurred = false
//        updateDefaults()
//    }
//}

class CoachMarksUserDefaults: ObservableObject {
    private let defaults: UserDefaults
    
    @Published private(set) var interactionFlags: [String: Bool] = [:] 

    @Published private(set) var viewCounts: [String: Int] = [:] 

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        if let coachMarks = defaults.dictionary(forKey: "coachMarks") {
            viewCounts = coachMarks.compactMapValues { $0 as? Int }
            interactionFlags = coachMarks.compactMapValues { $0 as? Bool }
        }
    }
    
    private func updateDefaults() {
        var coachMarks = [String: Any]()
        
        let filteredViewCounts = viewCounts.filter { !$0.key.hasSuffix("_interactionFlag") }
        coachMarks.merge(filteredViewCounts, uniquingKeysWith: { $1 })
        
        coachMarks.merge(interactionFlags, uniquingKeysWith: { $1 })
        defaults.set(coachMarks, forKey: "coachMarks")
    }
    
    func initialiseValues(interactionKey: String, viewKey: String) {
        if interactionFlags[interactionKey] == nil {
            interactionFlags[interactionKey] = false
        }
        
        if viewCounts[viewKey] == nil {
            viewCounts[viewKey] = 0
        }
    }

    func incrementViewCount(forKey baseKey: String) {
        let key = baseKey + "_viewCount"
        viewCounts[key, default: 0] += 1
        updateDefaults()
    }

    func setInteraction(forKey baseKey: String) {
        let key = baseKey + "_interactionFlag"
        interactionFlags[key] = true
        updateDefaults()
    }

    func viewCount(forKey key: String) -> Int {
        return viewCounts[key, default: 0]
    }

    func interactionOccurred(forKey key: String) -> Bool {
        return interactionFlags[key, default: false]
    }

    //TODO: Delete later, this is just for testing purposes:
    func resetCoachMarks() {
        viewCounts = [:]
        interactionFlags = [:]
        updateDefaults()
    }
}

@propertyWrapper
struct CoachMarkWrapper: DynamicProperty {
    private let keyBase: String
    private let threshold: Int
    @ObservedObject private var userDefaults: CoachMarksUserDefaults
    
    var wrappedValue: Bool {
        let viewCountKey = "\(keyBase)_viewCount"
        let interactionKey = "\(keyBase)_interactionFlag"
        return userDefaults.viewCount(forKey: viewCountKey) >= threshold &&
               !userDefaults.interactionOccurred(forKey: interactionKey)
    }
    
    var projectedValue: CoachMarksUserDefaults {
        userDefaults
    }
    
    init(key: String, threshold: Int, userDefaults: CoachMarksUserDefaults = CoachMarksUserDefaults()) {
        self.keyBase = key
        self.threshold = threshold
        self.userDefaults = userDefaults
        userDefaults.initialiseValues(interactionKey: "\(key)_interactionFlag", viewKey: "\(key)_viewCount")
    }
}
