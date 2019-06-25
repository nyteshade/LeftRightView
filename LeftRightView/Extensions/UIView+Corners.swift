//
// Created by Harrison, Brielle on 2019-06-19.
// Copyright (c) 2019 com.paypal.checkout. All rights reserved.
//

import UIKit

extension UIView {
  /**
    Adds rounded corners as specified by the `UIRectCorner` values you
    supply. By default, this creates the rounded corner masks for all
    corners.
    
    - Parameters:
      - radius: this is a CGFloat value in points to round the corners by
      - corners: an array of [UIRectCorner] or some of the constants supplied
        by the Array<UIRectCorner> extensions such as `.allCorners`
   */
  func roundCorners(
    radius: CGFloat,
    corners: UIRectCorner = .allCorners
  ) {
    let path = UIBezierPath(
      roundedRect: bounds,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    let mask = CAShapeLayer()
    
    mask.path = path.cgPath
    layer.mask = mask
  }
}

