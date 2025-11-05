//  EXTENSIONS.swift
//  deosinaPW1
//
//  Created by Kriss Osina on 13.09.2025.
//

import Foundation
import UIKit

extension UIColor {
    static func fromHex(_ hex: String) -> UIColor {
        var hexString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        guard hexString.count == 6 else {
            return UIColor.systemIndigo
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        return UIColor(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
    
    static func randomHex() -> UIColor {
        let randomHexInt = Int.random(in: 0...0xFFFFFF)
        let hexString = String(format: "%06X", randomHexInt)
        return UIColor.fromHex(hexString)
    }
}
