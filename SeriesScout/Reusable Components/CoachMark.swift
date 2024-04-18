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
    let spacingToDirectedView: CGFloat
    let pointerPlacement: PointerPlacement
    let onDismiss: () -> Void
    
    //TODO: Currently have a SwiftUI method. Should also make a UIKit version. Use Gemini?
    
    func makeView() -> some View {
        //TODO: Add animation?
        
        ZStack(alignment: .topTrailing) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .center, spacing: 12) {
                    Text(message)
                        .font(messageFont)
                        .multilineTextAlignment(.center)
                        .foregroundColor(messageColor)
                        .frame(maxWidth: .infinity, alignment: .top)
                    Button(buttonText) {
                        onDismiss()
                    }
                    .buttonStyle(primaryButtonStyle)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(width: 350, alignment: .top)
            .background(.white)
            .cornerRadius(12)
            
            PointerView(pointer: Pointer(), width: 24, height: 33, alignment: .trailing, pointerPlacement: pointerPlacement)
        }
        .padding(.top, 18 + spacingToDirectedView)
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
}
