//
//  CoachMark.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 06/04/2024.
//

import Foundation
import SwiftUI

struct CoachMarkView: View {
    
    // Requirements to take into consideration: Different screen sizes, scroll view
    // TODO: Try different test view configurations to initialise it with.
    // TODO: Try out TipKit
    // TODO: Look how other people have implemented tooltips to see how they are working out directions and whatnot.
    
    let title: String
    let message: String
    let buttonText: String
    let pointerPlacement: PointerView.PointerPlacement // Recommend against doing this: Have a preferred location: Left, Right, Top or Bottom. It needs to be dynamic so that it changes according to where the view is.
    let userDefaults: CoachMarksUserDefaults
    let key: String
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .center, spacing: 12) {
                Text(title)
                    .font(Constants.titleFont)
                    .foregroundStyle(Constants.messageColor)
                Text(message)
                    .font(Constants.messageFont)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Constants.messageColor)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .fixedSize(horizontal: false, vertical: true)
                
                Button(buttonText) {
                    userDefaults.setInteraction(forKey: key)
                    //TODO: Currently, this is the only thing preventing users from seeing it again once it displays to them. If they navigate back and return, coachmarks will persist. I need to handle this scenario.
                }
                .buttonStyle(primaryButtonStyle)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(width: 350, alignment: .top)
            .background(.white)
            .cornerRadius(12)
            
            PointerView(width: 24, height: 33, alignment: .trailing, pointerPlacement: pointerPlacement)
        }
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

struct CoachMarkModifier: ViewModifier {
    var coachMarkWrapper: CoachMarkWrapper
    let spacing: CGFloat
    let coachMarkType: CoachMarkFactory.CoachMarkType

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if coachMarkWrapper.wrappedValue {
                    GeometryReader { geometry in
                        let coachMark = CoachMarkFactory.createCoachMark(
                            type: coachMarkType,
                            userDefaults: coachMarkWrapper.projectedValue,
                            key: coachMarkWrapper.keyBase
                        )
                        coachMark
                            .padding(.top, geometry.frame(in: .local).maxY + spacing + 23)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                }
            }
    }
}

extension View {
    func coachMark(coachMarkWrapper: CoachMarkWrapper, spacing: CGFloat, type: CoachMarkFactory.CoachMarkType) -> some View {
        modifier(CoachMarkModifier(coachMarkWrapper: coachMarkWrapper, spacing: spacing, coachMarkType: type))
    }
}

struct CoachMarkFactory {
    enum CoachMarkType {
        case shortlist
    }
    
    static func createCoachMark(type: CoachMarkType, userDefaults: CoachMarksUserDefaults, key: String) -> CoachMarkView {
        switch type {
        case .shortlist:
            return shortlistCoachMark(userDefaults: userDefaults, key: key)
        }
    }
    
    static func shortlistCoachMark(userDefaults: CoachMarksUserDefaults, key: String) -> CoachMarkView {
        CoachMarkView(title: Constants.shortlistTitle,
                      message: Constants.shortlistMessage,
                      buttonText: Constants.buttonText,
                      pointerPlacement: .topRight,
                      userDefaults: userDefaults,
                      key: key)
    }
    
    struct Constants {
        static let shortlistTitle = "Add to your shortlist"
        static let shortlistMessage = "You can save and compare your favourite holidays by adding them to your shortlist"
        static let buttonText = "Got it"
    }
}
