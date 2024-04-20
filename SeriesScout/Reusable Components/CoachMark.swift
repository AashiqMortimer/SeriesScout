//
//  CoachMark.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 06/04/2024.
//

import Foundation
import SwiftUI

struct CoachMark {
    let message: String
    let messageFont: Font
    let messageColor: Color
    let buttonText: String
    let pointerPlacement: PointerView.PointerPlacement
    let onDismiss: () -> Void
    
    // James agreed that I will only do a SwiftUI version.
    
    func makeView() -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .center, spacing: 12) {
                Text(message)
                    .font(messageFont)
                    .multilineTextAlignment(.center)
                    .foregroundColor(messageColor)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .fixedSize(horizontal: false, vertical: true)
                
                Button(buttonText) {
                    onDismiss()
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
        CoachMark(message: Constants.shortlistMessage,
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
        static let shortlistMessage = "Did you know you can save your favourite holidays and add them to your shortlist?"
        static let buttonText = "Got it"
        static let coachFont = Font.custom("TUITypeLight-Regular", size: 17)
    }
}
