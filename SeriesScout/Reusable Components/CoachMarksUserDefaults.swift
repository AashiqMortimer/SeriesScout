//
//  CoachMarksUserDefaults.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/04/2024.
//

import Foundation
import SwiftUI

class CoachMarksUserDefaults: ObservableObject {
    
    // Change to: CoachMarksStorage
    // Initialiser 
    
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

    func incrementViewCount(for coachMark: CoachMark) {
        viewCounts[coachMark.viewCountKey, default: 0] += 1
        updateDefaults()
    }

    func setInteraction(for coachMark: CoachMark) {
        interactionFlags[coachMark.interactionFlagKey] = true
        updateDefaults()
    }

    //TODO: Delete later, this is just for testing purposes:
    func resetCoachMarks() {
        viewCounts = [:]
        interactionFlags = [:]
        updateDefaults()
    }
}

@propertyWrapper
struct CoachMark: DynamicProperty {
    let keyBase: String
    private let threshold: Int
    @ObservedObject private var coachMarksDefaults: CoachMarksUserDefaults
    
    var wrappedValue: Bool {
        return coachMarksDefaults.viewCounts[self.viewCountKey, default: 0] >= 
        threshold &&
        !coachMarksDefaults.interactionFlags[self.interactionFlagKey, default: false]
    }
    
    var projectedValue: CoachMarksUserDefaults {
        coachMarksDefaults
    }
    
    var viewCountKey: String {
        return "\(keyBase)_viewCount"
    }
    
    var interactionFlagKey: String {
        return "\(keyBase)_interactionFlag"
    }
    
    init(key: String, threshold: Int, userDefaults: CoachMarksUserDefaults = CoachMarksUserDefaults()) {
        self.keyBase = key
        self.threshold = threshold
        self.coachMarksDefaults = userDefaults
        userDefaults.initialiseValues(interactionKey: interactionFlagKey, viewKey: viewCountKey)
    }
}
