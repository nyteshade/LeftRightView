//
//  ConstraintExtensions.swift
//  PayPalCheckout
//
//  Created by Harrison, Brielle on 5/4/19.
//  Copyright © 2019 com.paypal.checkout. All rights reserved.
//

import UIKit

extension UIView {

  var yConstraint: NSLayoutConstraint? {
    get {
      return constraints.first(where: {
        $0.firstAttribute == .top && $0.relation == .equal
      })
    }
    set { setNeedsLayout() }
  }

  var xConstraint: NSLayoutConstraint? {
    get {
      return constraints.first(where: {
        $0.firstAttribute == .left && $0.relation == .equal
      })
    }
    set { setNeedsLayout() }
  }

  var heightConstraint: NSLayoutConstraint? {
    get {
      return constraints.first(where: {
        $0.firstAttribute == .height && $0.relation == .equal
      })
    }
    set { setNeedsLayout() }
  }

  var widthConstraint: NSLayoutConstraint? {
    get {
      return constraints.first(where: {
        $0.firstAttribute == .width && $0.relation == .equal
      })
    }
    set { setNeedsLayout() }
  }

  /**
    Tired of typing the same layout constraints over and over again? This
    handy little UIView extension will allow you to constrain a view to
    another view, possibly offset by some UIEdgeInsets.
   */
  public func constrain(to: UIView, _ offsetBy: UIEdgeInsets? = nil) {
    guard let _ = self.superview else {
      print("Unable to apply constraints when not in a view")
      return
    }

    let i: UIEdgeInsets = .init(
      top: offsetBy?.top ?? 0,
      left: offsetBy?.left ?? 0,
      bottom: offsetBy?.bottom ?? 0,
      right: offsetBy?.right ?? 0
    )

    self.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      self.topAnchor.constraint(equalTo: to.topAnchor, constant: i.top),
      self.leftAnchor.constraint(equalTo: to.leftAnchor, constant: i.top),
      self.rightAnchor.constraint(equalTo: to.rightAnchor, constant: i.right),
      self.bottomAnchor.constraint(equalTo: to.bottomAnchor, constant: i.bottom)
    ])
  }
}
