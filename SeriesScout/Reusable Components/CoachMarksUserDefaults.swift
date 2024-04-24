//
//  CoachMarksUserDefaults.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/04/2024.
//

import Foundation
import SwiftUI

class CoachMarksUserDefaults: ObservableObject {
    
    //TODO: Try this as a property wrapper again. (Dynamic Property Wrapper)
    // This should negate the ViewModel: You would just have this that has the viewCount, interactionOccurred, and shouldShow
    // WrappedValue and ProjectedValue.
    // Wrapped is a boolean to say if it should show the coach marks or not.
    // ProjectedValue would be my userdefaults properties that I have here as a class.
    // Would keep this class, alongside the property wrapper.
    
    
    // Ideal implementation within the View:
    // Initialise it: @Coachmark(key: "EAT-Shortlist, threshold: 3) var showShortlistCoachMark
    // $showShortlistCoachMark.incrementViewCounter()
    // $showShortlistCoachMark.markInteractionOcurred()
    
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
    
    //TODO: Delete later, this is just for testing purposes:
    func resetCoachMarks() {
        viewCount = 0
        interactionOccurred = false
        updateDefaults()
    }
}
