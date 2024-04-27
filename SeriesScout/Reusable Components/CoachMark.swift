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
    
    let title: String
    let message: String
    let buttonText: String
    let pointerPlacement: PointerView.PointerPlacement // Recommend against doing this: Have a preferred location: Left, Right, Top or Bottom. It needs to be dynamic so that it changes according to where the view is.
    let onDismiss: () -> Void
    
    // James agreed that I will only do a SwiftUI version.
    
    func makeView() -> some View {
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
    
    struct Constants {
        static let titleFont = Font.custom("AmbitBold", size: 17)
        static let messageFont = Font.custom("TUITypeLight-Regular", size: 17)
        static let messageColor = Color(red: 0.11, green: 0.07, blue: 0.36)
    }
}

//class CoachMarksViewModel: ObservableObject {
//    @Published var shouldShowCoachMark: Bool = false
//    
//    private let viewCountThreshold: Int
//    let coachMarksUserDefaults: CoachMarksUserDefaults
//    
//    init(viewKey: String, interactionKey: String, viewCountThreshold: Int) {
//        self.viewCountThreshold = viewCountThreshold
//        self.coachMarksUserDefaults = CoachMarksUserDefaults(viewKey: viewKey, interactionKey: interactionKey)
//        
//        checkShouldShowCoachMark()
//    }
//    
//    func incrementViewCount() {
//        coachMarksUserDefaults.incrementViewCount()
//        checkShouldShowCoachMark()
//    }
//    
//    func setInteractionOccurred() {
//        coachMarksUserDefaults.setInteraction()
//        checkShouldShowCoachMark()
//    }
//    
//    private func checkShouldShowCoachMark() {
//        shouldShowCoachMark = coachMarksUserDefaults.viewCount >= viewCountThreshold && !coachMarksUserDefaults.interactionOccurred
//    }
//    
//    //TODO: Delete later, this is just for testing purposes:
//    func resetCoachMarks() {
//        coachMarksUserDefaults.resetCoachMarks()
//        checkShouldShowCoachMark()
//    }
//}

struct CoachMarkModifier: ViewModifier {
    var shouldShowCoachMark: CoachMarks
    let coachMark: CoachMark
    let spacing: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if shouldShowCoachMark.wrappedValue {
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
    func coachMark(shouldShow: CoachMarks, coachMark: CoachMark, spacing: CGFloat) -> some View {
        modifier(CoachMarkModifier(shouldShowCoachMark: shouldShow, coachMark: coachMark, spacing: spacing))
    }
}

struct CoachMarkFactory {
    static func shortlistCoachMark(onDismiss: @escaping () -> Void) -> CoachMark {
        CoachMark(title: Constants.titleMessage,
                  message: Constants.shortlistMessage,
                  buttonText: Constants.buttonText,
                  pointerPlacement: .topRight, 
                  onDismiss: onDismiss)
    }
    
    struct Constants {
        static let titleMessage = "Add to your shortlist"
        static let shortlistMessage = "You can save and compare your favourite holidays by adding them to your shortlist"
        static let buttonText = "Got it"
    }
}
