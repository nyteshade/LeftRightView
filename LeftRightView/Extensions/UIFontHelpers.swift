//
//  UIFontHelpers.swift
//  NativeCheckout
//
//  Created by Harrison, Brielle on 5/12/19.
//  Copyright © 2019 com.paypal.checkout. All rights reserved.
//

import UIKit

/**
 A growing list of font variants that can be used with the list of
 font helpers below.
 */
public enum UIFontVariant: String, CaseIterable {
  case Regular = "Regular"
  case Bold = "Bold"
  case Black = "Black"
  case Oblique = "Oblique"
  case Book = "Book"
  case Roman = "Roman"
  case BookOblique = "BookOblique"
  case HeavyOblique = "HeavyOblique"
  case Italic = "Italic"
  case BoldItalic = "BoldItalic"
  case DemiBold = "DemiBold"
  case DemiBoldItalic = "DemiBoldItalic"
  case Heavy = "Heavy"
  case HeavyItalic = "HeavyItalic"
  case Medium = "Medium"
  case MediumItalic = "MediumItalic"
  case MediumOblique = "MediumOblique"
  case Light = "Light"
  case LightItalic = "LightItalic"
  case LightOblique = "LightOblique"
  case UltraLight = "UltraLight"
  case UltraLightItalic = "UltraLightItalic"
}

extension UIFont {
  /**
   Shortcut for specifying AvenirNext as a font in your code. AvenirNext
   supports the following variants: Bold, BoldItalic, DemiBold, DemiBoldItalic,
   Heavy, HeavyItalic, Italic, Medium, MediumItalic, Regular, UltraLight,
   and UltraLightItalic.

   - Parameters:
     - variant: one of the supported variant enums; see above
     - size: a size other than 12 points if desired.
   - Returns: either nil if the combo doesn't exist or a UIFont as specified
   */
  public static func AvenirNext(
    _ variant: UIFontVariant = .Regular,
    _ size: CGFloat = UIFont.systemFontSize
    ) -> UIFont? {
    return UIFont(name: "AvenirNext-\(variant.rawValue)", size: size)
  }

  /**
   Shortcut for specifying AvenirNext as a font in your code. AvenirNext
   supports the following variants: Black, BlackOblique, Book, BookOblique,
   Heavy, HeavyOblique, Light, LightOblique, Medium, MediumOblique, Oblique,
   Roman

   - Parameters:
   - variant: one of the supported variant enums; see above
   - size: a size other than 12 points if desired.
   - Returns: either nil if the combo doesn't exist or a UIFont as specified
   */
  public static func Avenir(
    _ variant: UIFontVariant = .Regular,
    _ size: CGFloat = UIFont.systemFontSize
    ) -> UIFont? {
    return UIFont(name: "AvenirNext-\(variant.rawValue)", size: size)
  }

  /**
    Convenience function for `boldSystemFont(of: size)` to make readabilty
    and usage throughout the code a bit easier.

    - Parameters:
      - size: either the value supplied or UIFont.systemFontSize
    - Returns: a system font in bold with the requested size, or
      UIFont.systemFontSize otherwise.
   */
  public static func bold(
    _ size: CGFloat? = nil
  ) -> UIFont {
    return UIFont.boldSystemFont(ofSize: size ?? UIFont.systemFontSize)
  }

  /**
    Convenience function for `italicSystemFont(of: size)` to make readabilty
    and usage throughout the code a bit easier.

    - Parameters:
      - size: either the value supplied or UIFont.systemFontSize
    - Returns: a system font in italics with the requested size, or
      UIFont.systemFontSize otherwise.
   */
  public static func italic(
    _ size: CGFloat? = nil
  ) -> UIFont {
    return UIFont.italicSystemFont(ofSize: size ?? UIFont.systemFontSize)
  }
}
