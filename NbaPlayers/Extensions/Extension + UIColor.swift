//
//  Extension + UIColor.swift
//  NbaPlayers
//
//  Created by Варвара Уткина on 12.11.2024.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        let r, g, b: CGFloat
        
        var hexColor = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexColor = hexColor.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexColor).scanHexInt64(&rgb) else { return nil }
        
        switch hexColor.count {
        case 3: // форматы RGB
            r = CGFloat((rgb >> 16) & 0xFF) / 255.0
            g = CGFloat((rgb >> 8) & 0xFF) / 255.0
            b = CGFloat(rgb & 0xFF) / 255.0
        case 6: // форматы RRGGBB
            r = CGFloat((rgb >> 16) & 0xFF) / 255.0
            g = CGFloat((rgb >> 8) & 0xFF) / 255.0
            b = CGFloat(rgb & 0xFF) / 255.0
        default:
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

