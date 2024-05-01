//
//  CoachMarksUserDefaults.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/04/2024.
//

import Foundation
import SwiftUI

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
struct CoachMark: DynamicProperty {
    let keyBase: String
    private let threshold: Int
    @ObservedObject private var coachMarksDefaults: CoachMarksUserDefaults
    
    var wrappedValue: Bool {
        let viewCountKey = "\(keyBase)_viewCount"
        let interactionKey = "\(keyBase)_interactionFlag"
        return coachMarksDefaults.viewCount(forKey: viewCountKey) >= threshold &&
               !coachMarksDefaults.interactionOccurred(forKey: interactionKey)
    }
    
    var projectedValue: CoachMarksUserDefaults {
        coachMarksDefaults
    }
    
    init(key: String, threshold: Int, userDefaults: CoachMarksUserDefaults = CoachMarksUserDefaults()) {
        self.keyBase = key
        self.threshold = threshold
        self.coachMarksDefaults = userDefaults
        userDefaults.initialiseValues(interactionKey: "\(key)_interactionFlag", viewKey: "\(key)_viewCount")
    }
}

//TODO: 1. Rename CoachMarkWrapper to @CoachMark
//TODO: 2. Instead of projectedValue as CoachMarksUserDefaults, have an object that manages the CoachMarksUserDefaults itself:
// Struct within CoachMarkWrapper, struct CoachMarkValue
// This will have the methods: setInteraction and incrementViewCount
// Idea behind this is that it will have access to the keyBase so we wouldnt have to pass that each time in the view.
// projectedValue can point to CoachMarkValue
