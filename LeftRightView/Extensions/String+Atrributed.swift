//
//  String+Atrributed.swift
//  PayPalCheckout
//
//  Created by Ali, Kaniz on 5/8/19.
//  Copyright © 2019 com.paypal.checkout. All rights reserved.
//

import UIKit 

/// The types are a bit long and as a shortcut, this makes much of the code
/// far more readable.
public typealias NSASMap = [NSAttributedString.Key: Any]

/// This function takes in a string and returns a bold text string
extension NSMutableAttributedString {
  /**
   Given the part of a string that should be bold, this function will modify
   the NSMutableAttributedString it is part of with an attribute that
   identifies the range in question and bolds it. By default
   */
  @discardableResult func bold(
    _ boldPart: String,
    _ specifiedFont: UIFont? = nil,
    _ size: CGFloat? = nil
  ) -> NSMutableAttributedString {
    let possibleRange = self.string.range(of: boldPart)

    guard
      let range = possibleRange,
      !range.isEmpty
      else {
        return self
    }

    self.setAttributes(
      [.font: UIFont.bold(size)],
      range: NSRange(range, in: self.string)
    )

    return self
  }
}

extension String {
  @discardableResult public func attributed(
    _ defAttributes: [NSAttributedString.Key: Any]? = nil
  ) -> NSMutableAttributedString {
    let attributes: NSASMap = defAttributes ?? [
      .font: UIFont.systemFont(ofSize: 12)
    ]

    return NSMutableAttributedString(string: self, attributes: attributes)
  }
}
