//
//  PointerView.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 07/04/2024.
//

import Foundation
import SwiftUI

struct PointerView: View {
    let pointer: PointerView.Pointer
    let width: CGFloat
    let height: CGFloat
    let alignment: Edge.Set
    let pointerPlacement: PointerView.PointerPlacement
    
    init(pointer: PointerView.Pointer = Pointer(), width: CGFloat, height: CGFloat, alignment: Edge.Set, pointerPlacement: PointerView.PointerPlacement) {
        self.pointer = pointer
        self.width = width
        self.height = height
        self.alignment = alignment
        self.pointerPlacement = pointerPlacement
    }

    var body: some View {
        pointer
            .fill(.white)
            .rotationEffect(.radians(pointerPlacement.direction))
            .frame(width: width, height: height)
            .offset(y: pointerPlacement.offset)
            .padding(alignment, pointerPlacement.padding)
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
}


