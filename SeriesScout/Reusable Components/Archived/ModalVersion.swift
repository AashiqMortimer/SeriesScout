//
//  ModalVersion.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 17/05/2024.
//

import Foundation
import SwiftUI

//struct CoachMarkViewModal: View {
//    
//    let title: String
//    let message: String
//    let buttonText: String
//    let userDefaults: CoachMarksUserDefaults
//    let key: String
//    
//    var body: some View {
//        VStack(alignment: .center, spacing: 12) {
//            Text(title)
//                .font(Constants.titleFont)
//                .foregroundStyle(Constants.messageColor)
//                .frame(maxWidth: .infinity)
//            Text(message)
//                .font(Constants.messageFont)
//                .multilineTextAlignment(.center)
//                .foregroundColor(Constants.messageColor)
//                .lineLimit(2)
//                .frame(maxWidth: 295)
//            
//            Button(buttonText) {
//                userDefaults.setInteraction(forKey: key)
//            }
//            .buttonStyle(primaryButtonStyle)
//            
////            Spacer()
//        }
//        .padding(.horizontal, 24)
//        .padding(.vertical, 24)
////        .fixedSize(horizontal: true, vertical: true)
//        .background(.white)
//        .cornerRadius(12)
////        .background(GeometryReader { proxy in
////            Color.clear.preference(key: CoachMarkHeightKey.self, value: proxy.size.height)
////        })
//    }
//    
//    let primaryButtonStyle = PrimaryButton(
//        backgroundColor: .blue,
//        foregroundColor: Color(.white),
//        font: Font.custom("Ambit-Bold", size: 18)
//    )
//    
//    struct Constants {
//        static let titleFont = Font.custom("AmbitBold", size: 17)
//        static let messageFont = Font.custom("TUITypeLight-Regular", size: 17)
//        static let messageColor = Color(red: 0.11, green: 0.07, blue: 0.36)
//    }
//}

//struct CoachMarkModalModifier: ViewModifier {
//    var coachMarkWrapper: CoachMark
//    let spacing: CGFloat
//    let coachMarkType: CoachMarkFactory.CoachMarkType
//
//    func body(content: Content) -> some View {
//        content
//            .overlay {
//                GeometryReader { proxy in
//                    let pointerHeight: CGFloat = 33
//                    let pointerWidth: CGFloat = 35
//                    
//                    let screenMidY = UIScreen.main.bounds.height / 2
//                    let globalMidY = proxy.frame(in: .global).midY
//                    
//                    let yPosition = globalMidY < screenMidY ?
//                    proxy.frame(in: .local).midY + pointerHeight + spacing :
//                    proxy.frame(in: .local).midY - pointerHeight + spacing + proxy.frame(in: .local).height
//                    
//                    let rotation = globalMidY < screenMidY ? Angle(degrees: 0) : Angle(degrees: 180)
//                    
//                    let coachMark = CoachMarkFactory.createCoachMark(
//                        type: coachMarkType,
//                        userDefaults: coachMarkWrapper.projectedValue,
//                        key: coachMarkWrapper.keyBase
//                    )
//                    
//                    ZStack {
//                        let coachMarkHeight = coachMarkWrapper.projectedValue.coachMarkHeight ?? 175
//                        
//                        coachMark
//                            .position(
//                                x: proxy.frame(in: .local).midX,
//                                y: globalMidY < screenMidY ?
//                                yPosition + (pointerHeight / 2) + (coachMarkHeight / 2) :
//                                    yPosition - (pointerHeight / 2) - (coachMarkHeight / 2) - (pointerHeight * 2)
//                            )
//                        
//                        Triangle()
//                            .frame(width: pointerWidth, height: pointerHeight)
//                            .position(x: proxy.frame(in: .local).midX,
//                                      y: yPosition)
//                            .rotationEffect(rotation, anchor: .top)
//                    }
//                }
//                .onPreferenceChange(CoachMarkHeightKey.self) { newHeight in
//                    coachMarkWrapper.projectedValue.coachMarkHeight = newHeight
//                }
//                .zIndex(1)
//            }
//    }
//}
//
//extension View {
//    func coachMarkModal(coachMarkWrapper: CoachMark, spacing: CGFloat, type: CoachMarkFactory.CoachMarkType) -> some View {
//        modifier(CoachMarkModalModifier(coachMarkWrapper: coachMarkWrapper, spacing: spacing, coachMarkType: type))
//    }
//}

//struct TestView3: View {
//    @CoachMark(key: Constants.key, threshold: 0) var showCoachMark
//    //TODO: Can I combine the wrapper initialisation with the modifier
//    
//    var body: some View {
//        VStack {
//            VStack(spacing: 10) {
//                Button("Top Screen Button"){
//                    $showCoachMark.setInteraction(forKey: Constants.key)
//                }
//                .buttonStyle(.borderedProminent)
//                
//                Text("Test313313131313133131")
//                
//                Text("This is a test space")
//                    .foregroundStyle(.white)
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 40)
//                    .background(.red)
//                    .padding(.bottom, 10)
//                    
//                Text("Visits \($showCoachMark.viewCounts[Constants.key + "_viewCount"] ?? 0)")
//                    .foregroundStyle(.white)
//                    .frame(width: 250, height: 30)
//                    .background(.green)
//                Text("Interacted: \($showCoachMark.interactionFlags[Constants.key + "_interactionFlag"]?.description ?? false.description)")
//                    .foregroundStyle(.white)
//                    .frame(width: 250, height: 30)
//                    .background(.yellow)
//                HStack(spacing: 200) {
//                    Text("Nothing")
//                        .hidden()
//                    Button("Shortlist"){
//                        $showCoachMark.setInteraction(forKey: Constants.key)
//                    }
//                    .buttonStyle(.borderedProminent)
////                    .coachMarkModal(coachMarkWrapper: _showCoachMark, spacing: 15, type: .shortlist)
//                    .popover(isPresented: .constant(showCoachMark), content: {
//                        CoachMarkFactory.shortlistCoachMark(userDefaults: $showCoachMark, key: Constants.key)
//                            .presentationCompactAdaptation(.none)
//                            .presentationBackground(.white)
//                    })
////                    .popover(
////                        isPresented: .constant(showCoachMark),
////                        attachmentAnchor: .point(.top),
////                        arrowEdge: .bottom,
////                        content: {
////                            CoachMarkFactory.shortlistCoachMark(userDefaults: $showCoachMark, key: Constants.key)
////                        })
////                    .fullScreenCover(
////                        isPresented: .constant(showCoachMark),
////                        onDismiss: {
////                            $showCoachMark.setInteraction(forKey: Constants.key)
////                        },
////                        content: {
////                        CoachMarkFactory.shortlistCoachMark(userDefaults: $showCoachMark, key: Constants.key)
////                    })
//                }
//            }
//            .frame(height: 600)
//            
//            VStack(spacing: 20) {
//                Text("Nothing")
//                    .hidden()
//                Button("Reset UserDefaults") {
//                    $showCoachMark.resetCoachMarks()
//                }
//                .buttonStyle(.borderedProminent)
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(.gray)
//        .onAppear(perform: {
//            $showCoachMark.incrementViewCount(forKey: Constants.key)
//        })
//    }
//    
//    struct Constants {
//        static let key = "EAT-Shortlist-Test2"
//    }
//}
//
//#Preview {
//    TestView3()
//}
