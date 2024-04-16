//
//  CoachMarksUserDefaults.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/04/2024.
//

import Foundation
import SwiftUI

class CoachMarksUserDefaults: ObservableObject {
    private let viewKey: String
    private let interactionKey: String
    
    @Published var interactionOccurred: Bool = false
    @Published var viewCount: Int = 0
    
    private var defaults: UserDefaults
    
    init(viewKey: String, interactionKey: String, defaults: UserDefaults = .standard) {
        self.viewKey = viewKey
        self.interactionKey = interactionKey
        self.defaults = defaults
        
        if let coachMarks = defaults.dictionary(forKey: "coachMarks") {
            interactionOccurred = coachMarks[interactionKey] as? Bool ?? false
            viewCount = coachMarks[viewKey] as? Int ?? 0
        }
    }
    
    private func updateDefaults() {
        var coachMarks = defaults.dictionary(forKey: "coachMarks") ?? [:]
        coachMarks[viewKey] = viewCount
        coachMarks[interactionKey] = interactionOccurred
        defaults.set(coachMarks, forKey: "coachMarks")
    }
    
    func incrementViewCount() {
        viewCount += 1
        updateDefaults()
    }
    
    func setInteraction() {
        guard !interactionOccurred else { return }
        interactionOccurred = true
        updateDefaults()
    }
}
