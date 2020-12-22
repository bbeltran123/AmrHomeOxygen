//
//  UIColor.swift
//  HomeOxygenApp
//
//  Created by Amr Mousa on 10.8.2020.
//  Copyright © 2020 Amr Mousa. All rights reserved.
//

import Foundation

import UIKit

extension UIColor {
    public convenience init?(hex: String, alpha:CGFloat = 1) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber >> 16) & 0xff) / 255
                    g = CGFloat((hexNumber >> 08) & 0xff) / 255
                    b = CGFloat((hexNumber >> 00) & 0xff) / 255
                    a = alpha

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
