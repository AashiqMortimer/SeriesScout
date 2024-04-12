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
    //TODO: Removed buttonStyle as a property because I wasn't able to pass in a 'ButtonStyle' type. Need to figure out a way to make the button styling more customisable. (Note: ButtonWrapper.swift in TDA is where the styles are)
//    var buttonStyle: ButtonStyle
    let buttonText: String
    let spacingToDirectedView: CGFloat
    
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
                    Button(buttonText) {} //TODO: Code to dismiss View.
                        .buttonStyle(primaryButtonStyle)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(width: 350, alignment: .top)
            .background(.white)
            .cornerRadius(12)
            
            PointerView(pointer: Pointer(), width: 24, height: 33, alignment: .trailing, pointerPlacement: .topRight)
        }
        .padding(.top, 33 + spacingToDirectedView)
    }
    
    let primaryButtonStyle = PrimaryButton(
        backgroundColor: .blue,
        foregroundColor: Color(.white),
        font: Font.custom("Ambit-Bold", size: 18)
    )
}
