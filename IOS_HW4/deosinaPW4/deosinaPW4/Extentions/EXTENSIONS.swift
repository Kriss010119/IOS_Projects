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

extension UIView {
    func pin(to view: UIView, _ constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: constant),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant)
        ])
    }
    
    func pinHorizontal(to view: UIView, _ constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant)
        ])
    }
    
    func pinTop(to anchor: NSLayoutYAxisAnchor, _ constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
    func pinBottom(to anchor: NSLayoutYAxisAnchor, _ constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        bottomAnchor.constraint(equalTo: anchor, constant: -constant).isActive = true
    }
    
    func pinBottom(to view: UIView, _ constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant).isActive = true
    }
}
