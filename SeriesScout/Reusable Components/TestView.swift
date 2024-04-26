//
//  Test.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 06/04/2024.
//

import SwiftUI
import UIKit

struct TestView: View {
    @StateObject private var coachMarksViewModel = CoachMarksViewModel(viewKey: Constants.counterKey, interactionKey: Constants.interactionKey, viewCountThreshold: 3)
    
    var body: some View {
        VStack {
            Text("This is a test space")
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(.red)
                .padding(.bottom, 10)
            Text("Visits \(coachMarksViewModel.coachMarksUserDefaults.viewCount)")
                .foregroundStyle(.white)
                .frame(width: 250, height: 30)
                .background(.green)
            Text("Interacted: \(coachMarksViewModel.coachMarksUserDefaults.interactionOccurred ? "Interacted" : "Not Interacted")")
                .foregroundStyle(.white)
                .frame(width: 250, height: 30)
                .background(.yellow)
            Button("Shortlist"){
                coachMarksViewModel.setInteractionOccurred()
            }
            .buttonStyle(.borderedProminent)
            .padding(.leading, 300)
            .coachMark(shouldShow: $coachMarksViewModel.shouldShowCoachMark,
                       coachMark: CoachMarkFactory.shortlistCoachMark(onDismiss:
                                                                        coachMarksViewModel.setInteractionOccurred),
                       spacing: 15)
            Button("Reset UserDfaults") {
                coachMarksViewModel.resetCoachMarks()
            }
            .buttonStyle(.borderedProminent)
            .offset(y: 250)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
        .onAppear(perform: {
            coachMarksViewModel.incrementViewCount()
        })
    }
    
    let primaryButtonStyle = PrimaryButton(
        backgroundColor: .blue,
        foregroundColor: Color(.white),
        font: Font.custom("Ambit-Bold", size: 18)
    )
    
    struct Constants {
        static let counterKey = "shortlistViewCount"
        static let interactionKey = "hasInteractedWithShortlist"
    }
}

public struct PrimaryButton: ButtonStyle {
    
    // MARK: - Properties

    let backgroundColor: Color
    let foregroundColor: Color
    let font: Font

    // MARK: - Body

    @Environment(\.isEnabled) var isEnabled
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .frame(height: 44.0)
            .frame(maxWidth: .infinity)
            .foregroundColor(foregroundColor)
            .background(Color(backgroundColor.opacity(
                isEnabled ? (configuration.isPressed ? 0.9 : 1.0) : 0.4)))
            .font(font)
            .cornerRadius(22.0)
    }
    
    public init(backgroundColor: Color, foregroundColor: Color, font: Font) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.font = font
    }
}

#Preview {
    TestView()
}
