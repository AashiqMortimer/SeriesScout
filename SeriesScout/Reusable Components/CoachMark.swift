//
//  CoachMark.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 06/04/2024.
//

import Foundation
import SwiftUI

struct CoachMarkView: View {
    
    let title: String
    let message: String
    let buttonText: String
    let storage: CoachMark
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(title)
                .font(Constants.titleFont)
                .foregroundStyle(Constants.messageColor)
                .frame(maxWidth: .infinity)
            Text(message)
                .font(Constants.messageFont)
                .multilineTextAlignment(.center)
                .foregroundColor(Constants.messageColor)
                .lineLimit(2)
                .frame(maxWidth: 295, maxHeight: .infinity)
            
            Button(buttonText) {
                storage.projectedValue.setInteraction(for: storage)
            }
            .buttonStyle(primaryButtonStyle)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .fixedSize(horizontal: true, vertical: true)
        .background(.white)
        .cornerRadius(12)
        .onDisappear(perform: {
            storage.projectedValue.setInteraction(for: storage)
        })
    }
    
    let primaryButtonStyle = PrimaryButton(
        backgroundColor: .blue,
        foregroundColor: Color(.white),
        font: Font.custom("Ambit-Bold", size: 18)
    )
    
    struct Constants {
        static let titleFont = Font.custom("AmbitBold", size: 17)
        static let messageFont = Font.custom("TUITypeLight-Regular", size: 17)
        static let messageColor = Color(red: 0.11, green: 0.07, blue: 0.36)
    }
}

//struct CoachMarkFactory {
//    enum CoachMarkType {
//        case shortlist
//    }
//    
//    static func createCoachMark(type: CoachMarkType, userDefaults: CoachMarksUserDefaults, key: String) -> CoachMarkView {
//        switch type {
//        case .shortlist:
//            return shortlistCoachMark(userDefaults: userDefaults, key: key)
//        }
//    }
//    
//    static func shortlistCoachMark(userDefaults: CoachMarksUserDefaults, key: String) -> CoachMarkView {
//        CoachMarkView(title: Constants.shortlistTitle,
//                      message: Constants.shortlistMessage,
//                      buttonText: Constants.buttonText,
//                      userDefaults: userDefaults,
//                      key: key)
//    }
//    
//    struct Constants {
//        static let shortlistTitle = "Add to your shortlist"
//        static let shortlistMessage = "You can save and compare your favourite holidays by adding them to your shortlist"
//        static let buttonText = "Got it"
//    }
//}

struct TestView2: View {
    @CoachMark(key: Constants.key, threshold: 0) var showShortlistCoachMark
    @State private var buttonFrame: CGRect = .zero
    //TODO: Can I combine the wrapper initialisation with the modifier
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                Button("Top Screen Button"){
                    $showShortlistCoachMark.setInteraction(for: _showShortlistCoachMark)
                }
                .buttonStyle(.borderedProminent)
//                .coachMark(coachMarkWrapper: _showShortlistCoachMark, spacing: 15, type: .shortlist)
                
                Text("Test313313131313133131")
//                    .coachMark(coachMarkWrapper: _showShortlistCoachMark, spacing: 15, type: .shortlist)
                
                Text("This is a test space")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(.red)
                    .padding(.bottom, 10)
                    
                Text("Visits \($showShortlistCoachMark.viewCounts[Constants.key + "_viewCount"] ?? 0)")
                    .foregroundStyle(.white)
                    .frame(width: 250, height: 30)
                    .background(.green)
                Text("Interacted: \($showShortlistCoachMark.interactionFlags[Constants.key + "_interactionFlag"]?.description ?? false.description)")
                    .foregroundStyle(.white)
                    .frame(width: 250, height: 30)
                    .background(.yellow)
                HStack(spacing: 200) {
                    Text("Nothing")
                        .hidden()
                    Button("Shortlist"){
                        $showShortlistCoachMark.setInteraction(for: _showShortlistCoachMark)
                    }
                    .background(GeometryReader { geometry in
                        Color.clear.onAppear {
                            buttonFrame = geometry.frame(in: .global)
                        }
                    }) // TODO: This is a good interim solution: With this, I should definitely be able to overlap everything with a modifier that is applied to the whole view. Then, I wonder if I might be able to position it centrally by not feeding in its frame for the x axis.
                    .buttonStyle(.borderedProminent)
                }
            }
            .frame(height: 600)
            
            VStack(spacing: 20) {
                Text("Nothing")
                    .hidden()
                Button("Reset UserDefaults") {
                    $showShortlistCoachMark.resetCoachMarks()
                }
                .buttonStyle(.borderedProminent)
//                .coachMark(coachMarkWrapper: _showShortlistCoachMark, spacing: 15, type: .shortlist)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
        .onAppear(perform: {
            $showShortlistCoachMark.incrementViewCount(for: _showShortlistCoachMark)
        })
//        .coachMark(coachMarkWrapper: _showShortlistCoachMark, spacing: 15, type: .shortlist, coachedFeature: buttonFrame)
    }
    
    struct Constants {
        static let key = "EAT-Shortlist-Test"
    }
}

#Preview {
    TestView2()
}
