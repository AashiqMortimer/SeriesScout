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

@propertyWrapper
struct CoachMarksv2: DynamicProperty {
    let baseKey: String
    let threshold: Int
    
}

//@propertyWrapper
//struct CoachMarks: DynamicProperty {
//    private let baseKey: String
//    private let threshold: Int
//    private let defaults: UserDefaults
//
//    @State private var interactionOccurred: Bool = false
//    @State private var viewCount: Int = 0
//
//    var wrappedValue: Bool {
//        get {
//            // Load values from UserDefaults
//            if let coachMarks = defaults.dictionary(forKey: "coachMarks") {
//                viewCount = coachMarks["\(baseKey)_viewKey"] as? Int ?? 0
//                interactionOccurred = coachMarks["\(baseKey)_interactionKey"] as? Bool ?? false
//            }
//
//            // Increment, update UserDefaults, and calculate result
//            viewCount += 1
//            updateDefaults()
//            let conditionalCheck = viewCount >= threshold && !interactionOccurred
//            return conditionalCheck
//        }
//
//        nonmutating set {
//            let conditionalCheck = viewCount >= threshold && !interactionOccurred
//            if !conditionalCheck { // Only update if coach marks have been dismissed
//                interactionOccurred = true
//                updateDefaults()
//            }
//        }
//    }
//
//    var projectedValue: CoachMarks {
//        return self
//    }
//
//    init(key: String, threshold: Int, defaults: UserDefaults = .standard) {
//        self.baseKey = key
//        self.threshold = threshold
//        self.defaults = defaults
//    }
//
//    private func updateDefaults() {
//        var coachMarks = defaults.dictionary(forKey: "coachMarks") ?? [:]
//        coachMarks["\(baseKey)_viewKey"] = viewCount
//        coachMarks["\(baseKey)_interactionKey"] = interactionOccurred
//        defaults.set(coachMarks, forKey: "coachMarks")
//    }
//
//    func incrementViewCount() {
//        viewCount += 1
//        updateDefaults()
//    }
//
//    func setInteractionOccurred() {
//        interactionOccurred = true
//        updateDefaults()
//    }
//
//    func resetCoachMarks() {
//        viewCount = 0
//        interactionOccurred = false
//        updateDefaults()
//    }
//}

//@propertyWrapper
//struct CoachMarks: DynamicProperty {
//    private let baseKey: String
//    private let threshold: Int
//    private let defaults: UserDefaults
//    
//    @State private var interactionOccurred: Bool = false
//    @State private var viewCount: Int = 0
//    
//    var wrappedValue: Bool {
//        viewCount >= threshold && !interactionOccurred
//    }
//    
//    var projectedValue: Binding<Bool> {
//        Binding(
//            get: { self.wrappedValue },
//            set: { newValue in
//                if !newValue {
//                    self.setInteractionOccurred()
//                }
//            }
//        )
//    }
//    
//    init(key: String, threshold: Int, defaults: UserDefaults = .standard) {
//        self.baseKey = key
//        self.threshold = threshold
//        self.defaults = defaults
//        
//        if let coachMarks = defaults.dictionary(forKey: "coachMarks") {
//            _interactionOccurred = State(initialValue: coachMarks["\(key)_interactionKey"] as? Bool ?? false)
//            _viewCount = State(initialValue: coachMarks["\(key)_viewKey"] as? Int ?? 0)
//        }
//    }
//    
//    private func updateDefaults() {
//        var coachMarks = defaults.dictionary(forKey: "coachMarks") ?? [:]
//        coachMarks["\(baseKey)_viewKey"] = viewCount
//        coachMarks["\(baseKey)_interactionKey"] = interactionOccurred
//        defaults.set(coachMarks, forKey: "coachMarks")
//    }
//    
//    func incrementViewCount() {
//        viewCount += 1
//        updateDefaults()
//    }
//    
//    func setInteractionOccurred() {
//        interactionOccurred = true
//        updateDefaults()
//    }
//    
//    func resetCoachMarks() {
//        viewCount = 0
//        interactionOccurred = false
//        updateDefaults()
//    }
//}

@propertyWrapper
struct CoachMarkUserDefaults: DynamicProperty {
    let baseKey: String
    let viewCountThreshold: Int
    private var viewKey: String { "\(baseKey)-viewKey" }
    private var interactionKey: String { "\(baseKey)-interactionKey" }
    
    var wrappedValue: [String: Any] {
        get { UserDefaults.standard.dictionary(forKey: "coachMarks") ?? [:] }
        set { UserDefaults.standard.set(newValue, forKey: "coachMarks") }
    }
    
    var shouldShowCoachMark: Bool {
        get {
            let viewCount = wrappedValue[viewKey] as? Int ?? 0
            let interactionOccurred = wrappedValue[interactionKey] as? Bool ?? false
            return viewCount >= viewCountThreshold && !interactionOccurred
        }
    }
    
    mutating func incrementViewCount() {
        var coachMarks = wrappedValue
        let viewCount = coachMarks[viewKey] as? Int ?? 0
        coachMarks[viewKey] = viewCount + 1
        wrappedValue = coachMarks
    }
    
    mutating func interactionOccurred() {
        var coachMarks = wrappedValue
        coachMarks[interactionKey] = true
        wrappedValue = coachMarks
    }
}
