//
//  UIView+LoadNib.swift
//  PayPalCheckout
//
//  Created by Ali, Kaniz on 5/18/19.
//  Copyright © 2019 com.paypal.checkout. All rights reserved.
//

import UIKit

extension UIView {
  /**
    This will take the first view defined in the nib defined by the named nib
    specified and return it. If a closure is supplied, it will be invoked with
    the loaded UIView as the first parameter.

    - Parameters:
      - owner: the name of the class, and it must be a class, that resides in
        the correct bundle in question.
      - nibName: the name of the nib that should be loaded
      - completion: an optional closure that should be executed if and only
        if the view is valid and loaded
   */
  @discardableResult static func createViewWithNib(
    owner: AnyClass,
    nibName: String,
    completion: ((UIView)->())? = nil
  ) -> UIView? {
    // Load nib
    let nib = Bundle(for: owner.self).loadNibNamed(
      nibName,
      owner: self,
      options: nil
    )

    if let nibView = nib![0] as? UIView {
      completion?(nibView)
      return nibView
    }

    return nil
  }
}
