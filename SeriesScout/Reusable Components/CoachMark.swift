//
//  CoachMark.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 06/04/2024.
//

import Foundation
import SwiftUI

struct CoachMark {
    
    // Requirements to take into consideration: Different screen sizes, scroll view
    // TODO: Try different test view configurations to initialise it with.
    // TODO: Try out TipKit
    // TODO: Look how other people have implemented tooltips to see how they are working out directions and whatnot.
    
    
    
    // Remove fonts and colors from the properties: Hard code the fonts and colours into the makeView method. We won't need to change fonts and colours from coach mark to coach mark.
    let title: String
    let titleFont: Font
    let message: String
    let messageFont: Font
    let messageColor: Color
    let buttonText: String
    let pointerPlacement: PointerView.PointerPlacement // Recommend against doing this: Have a preferred location: Left, Right, Top or Bottom. It needs to be dynamic so that it changes according to where the view is.
    let onDismiss: () -> Void
    
    // James agreed that I will only do a SwiftUI version.
    
    func makeView() -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .center, spacing: 12) {
                Text(title)
                    .font(titleFont)
                    .foregroundStyle(messageColor)
                Text(message)
                    .font(messageFont)
                    .multilineTextAlignment(.center)
                    .foregroundColor(messageColor)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .fixedSize(horizontal: false, vertical: true)
                
                Button(buttonText) {
                    onDismiss()
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
}

class CoachMarksViewModel: ObservableObject {
    @Published var shouldShowCoachMark: Bool = false
    
    private let viewCountThreshold: Int
    let coachMarksUserDefaults: CoachMarksUserDefaults
    
    init(viewKey: String, interactionKey: String, viewCountThreshold: Int) {
        self.viewCountThreshold = viewCountThreshold
        self.coachMarksUserDefaults = CoachMarksUserDefaults(viewKey: viewKey, interactionKey: interactionKey)
        
        checkShouldShowCoachMark()
    }
    
    func incrementViewCount() {
        coachMarksUserDefaults.incrementViewCount()
        checkShouldShowCoachMark()
    }
    
    func setInteractionOccurred() {
        coachMarksUserDefaults.setInteraction()
        checkShouldShowCoachMark()
    }
    
    private func checkShouldShowCoachMark() {
        shouldShowCoachMark = coachMarksUserDefaults.viewCount >= viewCountThreshold && !coachMarksUserDefaults.interactionOccurred
    }
    
    //TODO: Delete later, this is just for testing purposes:
    func resetCoachMarks() {
        coachMarksUserDefaults.resetCoachMarks()
        checkShouldShowCoachMark()
    }
}

struct CoachMarkModifier: ViewModifier {
    @Binding var shouldShowCoachMark: Bool
    let coachMark: CoachMark
    let spacing: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if shouldShowCoachMark {
                    GeometryReader { geometry in
                        coachMark.makeView()
                            .padding(.top, geometry.frame(in: .local).maxY + spacing + 23)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                }
            }
    }
}

extension View {
    func coachMark(shouldShow: Binding<Bool>, coachMark: CoachMark, spacing: CGFloat) -> some View {
        modifier(CoachMarkModifier(shouldShowCoachMark: shouldShow, coachMark: coachMark, spacing: spacing))
    }
}

struct CoachMarkFactory {
    static func shortlistCoachMark(onDismiss: @escaping () -> Void) -> CoachMark {
        CoachMark(title: Constants.titleMessage, 
                  titleFont: Constants.titleFont,
                  message: Constants.shortlistMessage,
                  messageFont: Constants.coachFont,
                  messageColor: Constants.textColor,
                  buttonText: Constants.buttonText,
                  pointerPlacement: .topRight, 
                  onDismiss: onDismiss)
    }
    
    struct Constants {
        static let userDefaultsKey = "coachMarks"
        static let counterKey = "shortlistViewCount"
        static let interactionKey = "hasInteractedWithShortlist"
        static let textColor: Color = Color(red: 0.11, green: 0.07, blue: 0.36)
        static let titleMessage = "Add to your shortlist"
        static let shortlistMessage = "You can save and compare your favourite holidays by adding them to your shortlist"
        static let buttonText = "Got it"
        static let coachFont = Font.custom("TUITypeLight-Regular", size: 17)
        static let titleFont = Font.custom("AmbitBold", size: 17)
//        static let titleFont = Font.title.weight(.bold)
    }
}
