//
//  UIColor+Hex+RGB.swift
//  PayPalCheckout
//
//  Created by Ali, Kaniz on 5/6/19.
//  Copyright © 2019 com.paypal.checkout. All rights reserved.
//

//Uitilty found at: https://medium.com/ios-os-x-development/a-smart-way-to-manage-colours-schemes-for-ios-applications-development-923ef976be55

import UIKit

extension UIColor {

  /**
    Creates an UIColor from HEX String in "#482937" format

    - Parameters:
      - hexString: HEX String in "#482937" format

    - Returns: UIColor from HexString
   */
  convenience init(hexString: String) {

    let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
    let scanner          = Scanner(string: hexString as String)

    if hexString.hasPrefix("#") {
      scanner.scanLocation = 1
    }
    var color: UInt32 = 0
    scanner.scanHexInt32(&color)

    let mask = 0x000000FF
    let r = Int(color >> 16) & mask
    let g = Int(color >> 8) & mask
    let b = Int(color) & mask

    let red   = CGFloat(r) / 255.0
    let green = CGFloat(g) / 255.0
    let blue  = CGFloat(b) / 255.0
    self.init(red:red, green:green, blue:blue, alpha:1)
  }
  
  
  /**
    Creates an UIColor Object based on provided RGB value in integer

    - Parameters:
      - red:   Red Value in integer (0-255)
      - green: Green Value in integer (0-255)
      - blue:  Blue Value in integer (0-255)

    - Returns: UIColor with specified RGB values
   */
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
}
