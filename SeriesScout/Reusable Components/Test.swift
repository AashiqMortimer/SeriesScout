//
//  Test.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 06/04/2024.
//

import SwiftUI
import UIKit

struct Test: View {
    var body: some View {
        VStack {
            Text("Test")
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(.red)
            coachMark
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
    
    var coachMark: some View {
        ZStack(alignment: .topTrailing) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .center, spacing: 12) {
                    Text("Did you know you can save your favourite holidays and add them to your shortlist?")
                        .font(Font.custom("TUITypeLight-Regular", size: 17))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Constants.textColor)
                        .frame(maxWidth: .infinity, alignment: .top)
                    Button("Got it") {}
                        .buttonStyle(primaryButtonStyle)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(width: 350, alignment: .top)
            .background(.white)
            .cornerRadius(12)
            
            Pointer().pointerView(width: 24, height: 33, alignment: .trailing)
        }
        .padding(.top, 48) // Would be good to calculate this on top of the height of the pointer (pointer height) + 15
    }
    
    let primaryButtonStyle = PrimaryButton(
        backgroundColor: .blue,
        foregroundColor: Color(.white),
        font: Font.custom("Ambit-Bold", size: 18)
    )
    
    struct Constants {
        static let textColor: Color = Color(red: 0.11, green: 0.07, blue: 0.36)
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

struct Pointer: Shape {
    func path(in rect: CGRect) -> Path {
            var path = Path()

            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

            return path
        }
    
    func pointerView(width: CGFloat, height: CGFloat, alignment: Edge.Set) -> some View {
        let pointerPlacement = PointerPlacement.topRight
        
        return Pointer()
            .fill(.white)
            .rotationEffect(.radians(pointerPlacement.direction))
            .frame(width: width, height: height)
            .offset(y: pointerPlacement.offset)
            .padding(alignment, pointerPlacement.padding)
    }
}

struct PointerPlacement {
    let offset: CGFloat
    let padding: CGFloat
    let direction: Double
    
    static let topRight = PointerPlacement(offset: -25, padding: 15, direction: .zero)
    static let topLeft = PointerPlacement(offset: -25, padding: 300, direction: .zero)
    static let bottomRight = PointerPlacement(offset: 109, padding: 15, direction: .pi)
    static let bottomLeft = PointerPlacement(offset: 109, padding: 300, direction: .pi)
    
    init(offset: CGFloat, padding: CGFloat, direction: Double) {
        self.offset = offset
        self.direction = direction
        self.padding = padding
    }
}

#Preview {
    Test()
}
