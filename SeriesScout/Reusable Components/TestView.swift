//
//  Test.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 06/04/2024.
//

import SwiftUI
import UIKit

struct TestView: View {
    @CoachMark(key: Constants.key, threshold: 3) var showShortlistCoachMark
    //TODO: Can I combine the wrapper initialisation with the modifier
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                Button("Top Screen Button"){
                    $showShortlistCoachMark.setInteraction(forKey: Constants.key)
                }
                .buttonStyle(.borderedProminent)
                .coachMark(coachMarkWrapper: _showShortlistCoachMark, spacing: 15, type: .shortlist)
                
                Text("Test")
                
                
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
                        $showShortlistCoachMark.setInteraction(forKey: Constants.key)
                    }
                    .buttonStyle(.borderedProminent)
        //            .padding(.leading, 300)
                    .coachMark(coachMarkWrapper: _showShortlistCoachMark, spacing: 15, type: .shortlist)
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
            $showShortlistCoachMark.incrementViewCount(forKey: Constants.key)
        })
    }
    
    var button1: some View {
        Button("Button 1") {}
            .buttonStyle(.borderedProminent)
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
