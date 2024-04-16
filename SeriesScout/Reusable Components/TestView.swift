//
//  Test.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 06/04/2024.
//

import SwiftUI
import UIKit

struct TestView: View {
    @StateObject private var coachMarksTracking = CoachMarksUserDefaults(viewKey: "shortlistViewCount", interactionKey: "shortlistButtonTapped")
    
    var body: some View {
        VStack {
            Text("This is a test space")
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(.red)
                .padding(.bottom, 10)
            Text("Visits \(coachMarksTracking.viewCount)")
                .foregroundStyle(.white)
                .frame(width: 250, height: 30)
                .background(.green)
            Text("Interacted: \(coachMarksTracking.interactionOccurred ? "Interacted" : "Not Interacted")")
                .foregroundStyle(.white)
                .frame(width: 250, height: 30)
                .background(.yellow)
            Button("Shortlist"){
                self.coachMarksTracking.setInteraction()
            }
            .buttonStyle(.borderedProminent)
            .offset(x: 145)
            
            coachMark.makeView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
        .onAppear(perform: {
            coachMarksTracking.incrementViewCount()
        })
    }
    
    let coachMark = CoachMark(message: Constants.coachmessage,
                              messageFont: Constants.coachFont,
                              messageColor: Constants.textColor,
                              buttonText: Constants.buttonText,
                              spacingToDirectedView: 15, 
                              pointerPlacement: .topRight)
    
    let primaryButtonStyle = PrimaryButton(
        backgroundColor: .blue,
        foregroundColor: Color(.white),
        font: Font.custom("Ambit-Bold", size: 18)
    )
    
    struct Constants {
        static let userDefaultsKey = "coachMarks"
        static let counterKey = "shortlistViewCount"
        static let interactionKey = "hasInteractedWithShortlist"
        static let textColor: Color = Color(red: 0.11, green: 0.07, blue: 0.36)
        static let coachmessage = "Did you know you can save your favourite holidays and add them to your shortlist?"
        static let buttonText = "Got it"
        static let coachFont = Font.custom("TUITypeLight-Regular", size: 17)
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
