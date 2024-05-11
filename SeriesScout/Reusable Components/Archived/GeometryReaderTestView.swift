//
//  GeometryReaderTestView.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 03/05/2024.
//

import SwiftUI

struct GeometryReaderTestView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 400) {
                HStack(spacing: 30) {
                    button1
//                        .modifier(Pointer(distanceToView: 15))
                    button2
    //                    .modifier(Pointer(distanceToView: 15))
                    button3
    //                    .modifier(Pointer(distanceToView: 15))
                        
                }
                HStack {
                    button5
    //                    .modifier(Pointer(distanceToView: 15))
                }
                HStack(spacing: 60) {
                    button4
//                        .modifier(Pointer(distanceToView: 15))
                    
                }
            }
        }
    }
    
    var button1: some View {
        Button("Button 1") {}
            .buttonStyle(.borderedProminent)
    }
    
    var button2: some View {
        Button("Button 2") {}
            .buttonStyle(.borderedProminent)
    }
    
    var button3: some View {
        Button("Button 3") {}
            .buttonStyle(.borderedProminent)
    }
    
    var button4: some View {
        Button("Button 4") {}
            .buttonStyle(.borderedProminent)
    }
    
    var button5: some View {
        Button("Button 5") {}
            .buttonStyle(.borderedProminent)
    }
}

struct Pointer: ViewModifier {
    let distanceToView: CGFloat
    
    func body(content: Content) -> some View {
        
        content
            .overlay {
                GeometryReader { proxy in
                    let pointerHeight: CGFloat = 33
                    let pointerWidth: CGFloat = 35
                    
                    let screenMidY = UIScreen.main.bounds.height / 2
                    let globalMidY = proxy.frame(in: .global).midY
                    
                    let yPosition = proxy.frame(in: .local).midY + pointerHeight + distanceToView
                    let rotation = globalMidY < screenMidY ? Angle(degrees: 0) : Angle(degrees: 180)
                    
                    Triangle().frame(width: pointerWidth, height: pointerHeight)
                        .position(x: proxy.frame(in: .local).midX,
                                  y: yPosition)
                        .rotationEffect(rotation)
                }
            }
            .background {
                
            }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

#Preview {
    GeometryReaderTestView()
}
