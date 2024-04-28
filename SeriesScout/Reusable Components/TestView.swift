//
//  Test.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 06/04/2024.
//

import SwiftUI
import UIKit

struct TestView: View {
    @CoachMarkWrapper(key: Constants.key, threshold: 3) var showShortlistCoachMark
    
    var body: some View {
        VStack {
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
            Text("Should Show: \(showShortlistCoachMark.description)")
                .foregroundStyle(.white)
                .frame(width: 250, height: 30)
                .background(.black)
            Button("Shortlist"){
                $showShortlistCoachMark.setInteraction(forKey: Constants.key)
            }
            .buttonStyle(.borderedProminent)
            .padding(.leading, 300)
            .coachMark(coachMarkWrapper: _showShortlistCoachMark, spacing: 15, type: .shortlist)
            
            Button("Reset UserDefaults") {
                $showShortlistCoachMark.resetCoachMarks()
            }
            .buttonStyle(.borderedProminent)
            .offset(y: 250)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
        .onAppear(perform: {
            $showShortlistCoachMark.incrementViewCount(forKey: Constants.key)
        })
    }
    
    let primaryButtonStyle = PrimaryButton(
        backgroundColor: .blue,
        foregroundColor: Color(.white),
        font: Font.custom("Ambit-Bold", size: 18)
    )
    
    struct Constants {
        static let key = "EAT-Shortlist"
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
