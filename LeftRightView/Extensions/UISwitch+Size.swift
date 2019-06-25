//
//  UISwitch+Size.swift
//  NativeCheckout
//
//  Created by Harrison, Brielle on 5/28/19.
//  Copyright © 2019 com.paypal.checkout. All rights reserved.
//

import UIKit

extension UISwitch {

  /**
    Adjusts the displayed size of the UISwitch instance to a smaller size. The
    magic numbers for height and width are taken from trial and error on the
    part of using the view.

    If `CGFloat.relativeToggleWidth` or `CGFloat.relativeToggleHeight` is
    passed in for either (never for both) of the appropriate values, then
    a relative transform value will be applied for opposite value.

    The following code will resize the switch to a height of 26 and equally
    diminished height will also be applied to keep the aspect the same. 

    ```
    var switch = UISwitch(...)
    switch.transformSize(.relativeToggleWidth, 26)
    ```

    - Parameters:
      - width: the desired width value
      - height: the desired height value
   */
  func transformSize(_ width: CGFloat = 51, _ height: CGFloat = 31) {

    guard
      (width != -1 && height == -1) ||
      (width == -1 && height != -1) ||
      (width != -1 && height != -1)
    else {
      return
    }

    let standardHeight: CGFloat = 31
    let standardWidth: CGFloat = 51

    var heightRatio = height / standardHeight
    var widthRatio = width / standardWidth

    if (height == -1) {
      heightRatio = (((width / standardWidth) * standardHeight)) / standardHeight
    }
    else if (width == -1) {
      widthRatio = ((height / standardHeight) * standardWidth) / standardWidth
    }

    transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
  }
}

extension CGFloat {
  public static var relativeToggleHeight: CGFloat { return -1 }
  public static var relativeToggleWidth: CGFloat { return -1 }
}
