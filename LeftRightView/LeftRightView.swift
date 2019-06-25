//
//  LeftRightView.swift
//  LeftRightView
//
//  Created by Harrison, Brielle on 6/24/19.
//  Copyright © 2019 Harrison, Brielle. All rights reserved.
//

import UIKit

/**
  A simple example that shows how a left and right view can be combined to
  store a compound view.
 */
class LeftRightView: UIView {
  // MARK: Properties

  /**
    The insets serve as the backing store to the default `alignmentRectInsets`
    value defined by `UIView` that enables the ability to add padding to a
    views constants. Whenever this value is set, the the view and its contents
    are flagged as dirty and are laid out again.
   */
  @IBInspectable var insets: UIEdgeInsets = .zero {
    didSet {
      setNeedsUpdateConstraints(); setNeedsLayout(); setNeedsDisplay()
    }
  }

  /**
    The left hand view of the LeftRightView. This view will appear on the left
    side of the view.
   */
  @IBOutlet var left: UIView?  {
    didSet {
      setNeedsUpdateConstraints(); setNeedsLayout(); setNeedsDisplay()
    }
  }

  /**
    The right hand view of the LeftRightView. This view will appear opposite
    the left view, thereby appearing on the right hand side.
   */
  @IBOutlet var right: UIView? {
    didSet {
      setNeedsUpdateConstraints(); setNeedsLayout(); setNeedsDisplay()
    }
  }

  // MARK: Layout & Overrides

  /**
    The intrinsic content size is overloaded to return whatever width the
    view currently offers plus the larger of the two calculated heights of
    its left and/or right hand views as a CGSize

    - Note: any padding stored in the insets property will be taken into
      account whenever the views sized.
   */
  override var intrinsicContentSize: CGSize {
    let t = insets.top
    let b = insets.bottom

    var l = left?.calculateOwnHeight(t, b, 0, .SizeUsingSubviewSums) ?? 0
    var r = right?.calculateOwnHeight(t, b, 0, .SizeUsingSubviewSums) ?? 0

    if let left = left as? LeftRightView {
      l = left.intrinsicContentSize.height
    }

    if let right = right as? LeftRightView {
      r = right.intrinsicContentSize.height
    }

    return CGSize(width: self.width, height: max(l, r))
  }

  /**
    The `layoutSubviews()` methods purpose is to place the left view on the
    left and right view on the right. If one view is shorter than the other,
    the smaller view will be centered vertically as compared to its sibling.

    - Note: any padding stored in the insets property will be taken into
      account whenever the views are laid out.
   */
  override func layoutSubviews() {
    let size = self.intrinsicContentSize
    let l = left?.calculateOwnHeight(0, 0, 0, .SizeUsingSubviewSums) ?? 0
    let r = right?.calculateOwnHeight(0, 0, 0, .SizeUsingSubviewSums) ?? 0

    self.size = size

    if let left = left {
      left.x = insets.left
      left.height = l
      left.frame = left.frame.centerHeight(size.height)
      left.y = max(0, left.y)
    }

    if let right = right {
      right.x = self.width - insets.right - right.width
      right.height = r
      right.frame = right.frame.centerHeight(size.height)
      right.y = max(0, right.y)
    }
  }

  /**
    This property, normally `UIEdgeInsets.zero` by default, will now reflect
    the contents of the `insets` property on this view.
   */
  override var alignmentRectInsets: UIEdgeInsets {
    return insets
  }

  // MARK: Initializers

  /**
    This convenience initializer takes an optional left and right view and
    sets their associated properties. Once set, the `.frame.size` of the view
    is updated to be whatever the internal `.intrinsicContentSize` property
    equates to.

    - Parameters:
      - left: the leftmost view of the container
      - right: the rightmost view of the container
   */
  convenience init(_ left: UIView?, _ right: UIView?) {
    self.init(frame: .zero)

    self.left = left
    self.right = right
    self.frame.size = self.intrinsicContentSize
  }

  // Overloaded initializers

  required init?(coder: NSCoder) { super.init(coder: coder) }
  override init(frame: CGRect) { super.init(frame: frame) }
}
