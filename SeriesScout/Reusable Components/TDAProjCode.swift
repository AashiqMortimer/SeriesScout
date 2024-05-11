//
//  TDAProjCode.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 06/05/2024.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import UIKit
import SwiftUI

@objc public extension UIDevice {

    class func currentDeviceIsPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    class func currentDeviceIsPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    class func currentDeviceIsSimulator() -> Bool {
        #if targetEnvironment(simulator)
          return true
        #else
          return false
        #endif
    }
    
    class func isLandscape() -> Bool {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            return true
        default:
            return false
        }
    }

    var wifiSSID: String? {
        guard let interfaces = CNCopySupportedInterfaces() as? [String] else { return nil }
        let key = kCNNetworkInfoKeySSID as String
        for interface in interfaces {
            guard let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? else { continue }
            return interfaceInfo[key] as? String
        }
        return nil
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
