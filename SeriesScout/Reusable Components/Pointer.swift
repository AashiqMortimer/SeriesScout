//
//  Pointer.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 07/04/2024.
//

import Foundation
import SwiftUI

//struct Pointer: Shape {
//    func path(in rect: CGRect) -> Path {
//            var path = Path()
//
//            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
//            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
//            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
//            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
//
//            return path
//        }
//    
//    func pointerView(width: CGFloat, height: CGFloat, alignment: Edge.Set) -> some View {
//        let pointerPlacement = PointerPlacement.topRight
//        
//        return Pointer()
//            .fill(.white)
//            .frame(width: width, height: height)
//            .offset(y: pointerPlacement.offset)
//            .padding(alignment, 15)
//    }
//}
//
//struct PointerPlacement {
//    let offset: CGFloat
//    let padding: CGFloat
//    
//    static let topRight = PointerPlacement(offset: -25, padding: 15)
//    static let topLeft = PointerPlacement(offset: 25, padding: 15)
//    static let bottomRight = PointerPlacement(offset: -25, padding: -15)
//    static let bottomLeft = PointerPlacement(offset: 25, padding: -15)
//    
//    init(offset: CGFloat, padding: CGFloat) {
//        self.offset = offset
//        self.padding = padding
//    }
//}
