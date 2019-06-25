//
//  UIView+Sizes.swift
//  NativeCheckout
//
//  Created by Harrison, Brielle on 5/16/19.
//  Copyright © 2019 com.paypal.checkout. All rights reserved.
//

import UIKit

extension CGRect {
  /**
   This property retrieves the bounds CGRect for the main UIScreen
   */
  public static var ScreenBounds: CGRect {
    return UIScreen.main.bounds
  }

  /**
   Since iOS devices support more than one screen at a given time, this
   method will returnt he bounds of all known screens in order.
   */
  public static var ScreensBounds: [CGRect] {
    var bounds = [CGRect]()

    for screen in UIScreen.screens {
      bounds.append(screen.bounds)
    }

    return bounds
  }
}

extension CGFloat {
  /// Retrieves the main screen's width as a CGFloat for easy use
  public static var ScreenWidth: CGFloat {
    return UIScreen.main.bounds.size.width
  }

  /// Retrieves the main screen's height as a CGFloat for easy use
  public static var ScreenHeight: CGFloat {
    return UIScreen.main.bounds.size.height
  }

  /// This property is the top safe area inset for the main key window
  public static var TopSafeArea: CGFloat {
    return UIEdgeInsets.KeySafeAreas.top
  }

  /// This property is the bottom safe area inset for the main key window
  public static var BottomSafeArea: CGFloat {
    return UIEdgeInsets.KeySafeAreas.bottom
  }
}

extension UIEdgeInsets {
  /// Returns the safeAreaInsets of the application's keyWindow. If there is
  /// no key window, an empty set of UIEdgeInsets will be returned instead.
  public static var KeySafeAreas: UIEdgeInsets {
    return UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets.zero
  }
}

/**
 The UIViewSizingOpts enumeration defines some of the ways that the following
 calculate*Heights functions work.
 */
public enum UIViewSizingOpts: Equatable {
  /// Calls to systemLayoutSizeFitting(:) optionally takes a constant size
  /// if a known frame is not given. These can be either one of the UIView
  /// constants `layoutFittingCompressedSize` or `layoutFittingExpandedSize`;
  /// this option denotes the former
  case layoutCompressedSize

  /// There is likely a `frame.size.height` value set on the view itself, if
  /// present, we are stating that we prefer that value to others
  case preferSetSize

  /// In some cases it might make sense to recursively call calculateHeight on
  /// each of the subviews and return that value. This option states the result
  /// of doing so is preferred to the calculated height (though both will be
  /// performed)
  case preferSubviewSum

  /// By default, when there is a preferred type of height, that value and the
  /// calculated value will be compared and the maximum of the two will be
  /// returned. If this option is present, the minimum of the two will be given
  /// instead.
  case minimumOfChoices

  /// Only applying to the calculation of subviews, if present any subviews y
  /// coordinate is also added to the final height, allowing for any calculated
  /// whitespace.
  case includeYOffset

  /// AutoLayout constraints can and often do affect the size value returned
  /// by the methods used to query for height. If this option is present, any
  /// active constraints are temporarily disabled while the sizes are being
  /// recalculated. Once the calculation is complete, they are reenabled.
  case temporarilyDisableConstraints

  /// This is a mutation that occurs to a views' origin.y coordinate as it
  /// walks the heights of the views. A given view will have a new y coordinate
  /// with curHeight as it traverses the items
  case mutateYByStackingVertically

  /// This is a mutation that occurs to views' size.width coordinates as it
  /// walks the heights of the views. A given view will have a new width
  /// size equal to what is supplied. Both the new CGFloat.ScreenWidth and
  /// CGFloat.ScreenHeight extensions are provided to make this easier.
  case mutateWidth(CGFloat)

  /// This mutation modifies the x coordinate of the view being iterated over
  /// by calculating a center offset using the width of the view and the
  /// width supplied.
  /// - ToDo: implement
  case mutateXByCenteringWithin(CGFloat)

  /// Slams any origin.x value to zero to be left aligned in the width supplied
  /// - ToDo: implement
  case mutateXToLeft

  /// Calculates the origin.x value that right aligns using the width supplied
  /// - ToDo: implement
  case mutateXToRightIn(CGFloat)
}

extension Array where Element == UIViewSizingOpts {
  /// This set of options includes only the hint to temporarily disable any
  /// active constraints during sizing.
  public static var Defaults: [UIViewSizingOpts] = [
    .temporarilyDisableConstraints
  ]

  /// Like the default settings this constant of settings also disables any
  /// active constraints, but it also uses a compressed layout fittment rather
  /// than an expanded fittment
  public static var SizeUsingCompressedSize: [UIViewSizingOpts] = [
    .layoutCompressedSize,
    .temporarilyDisableConstraints
  ]

  /// Like the defaults, constraints are disabled, but in this set the subview
  /// sizes are also calculated and are preferred to the calculated size
  public static var SizeUsingSubviewSums: [UIViewSizingOpts] = [
    .preferSubviewSum,
    .temporarilyDisableConstraints
  ]

  /// Like the defaults, constraints are disabled, but in this set the subview
  /// sizes are also calculated and are preferred to the calculated size. The
  /// coordinate is also taken into account with this set of options.
  public static var SizeUsingSubviewSumsAndY: [UIViewSizingOpts] = [
    .preferSubviewSum,
    .temporarilyDisableConstraints,
    .includeYOffset
  ]

  /// Stacks the views and disables their autolayout constraints while checking
  /// their size.
  public static var StackViews: [UIViewSizingOpts] = [
    .temporarilyDisableConstraints,
    .mutateYByStackingVertically,
    .mutateXToLeft
  ]

  /**
    This function returns a similar set of options as StackViews but adds a
    .mutateWidth element with the specified target width to apply to any set
    of processed views

    - Parameters:
      - width: the new width of the views being processed
   */
  public static func StackAndStretchViews(
    _ width: CGFloat
  ) -> [UIViewSizingOpts] {
    return [
      .temporarilyDisableConstraints,
      .mutateYByStackingVertically,
      .mutateWidth(width)
    ]
  }

  public func adding(opts: UIViewSizingOpts...) -> [UIViewSizingOpts] {
    var result = [UIViewSizingOpts]()

    result.append(contentsOf: self)
    result.append(contentsOf: opts)

    return result
  }

  public func except(opts: UIViewSizingOpts...) -> [UIViewSizingOpts] {
    var result = [UIViewSizingOpts]()

    result.append(contentsOf: self)
    for opt in opts {
      if result.contains(opt) {
        result.remove(at: result.firstIndex(of: opt)!)
      }
    }

    return result
  }
}

extension UIView {
  /**
   Walks through the subviews and calculates a total height, with an optional
   pre or post padding, and returns the value. The actual height of the view
   or its subviews are not modified.

    - Parameters:
      - padStart: any padding to be applied to the starting height
      - padEnd: and padding to be applied to the ending height
      - padPerSubview: any padding applied between each view when subviews are
        also calculated.
      - opts: an array of UIViewSizingOpts values to customize how the height
        of the view is calculated. 
    - Returns:
      a CGFloat denoting the calculated height
   */
  public func calculateOwnHeight(
    _ padStart: CGFloat = 0,
    _ padEnd: CGFloat = 0,
    _ padPerSubview: CGFloat = 0,
    _ opts: [UIViewSizingOpts] = .Defaults
    ) -> CGFloat {
    // Check the supplied options first so that we don't recurse the opts
    // array more than once
    let layoutCompressed: Bool = opts.contains(.layoutCompressedSize)
    let disableConstraints: Bool = opts.contains(.temporarilyDisableConstraints)
    let preferSetSize: Bool = opts.contains(.preferSetSize)
    let preferSubviewSize: Bool = opts.contains(.preferSubviewSum)
    let useMin: Bool = opts.contains(.minimumOfChoices)

    var resizeWidth: Bool = false
    var leftAlignX: Bool = false
    var centerAlignX: Bool = false
    var rightAlignX: Bool = false
    var mutate: Bool = false
    var width: CGFloat = superview?.width ?? -1

    /// Walk our options and see if we are specifying a way to modify the
    /// width of the view in question
    opts.forEach { opt in
      switch opt {
        case .mutateWidth(let newWidth):
          width = newWidth
          resizeWidth = true
          mutate = true

        case .mutateXToLeft:
          leftAlignX = true
          mutate = true

        case .mutateXToRightIn(let within):
          width = within
          rightAlignX = true
          mutate = true

        case .mutateXByCenteringWithin(let within):
          width = within
          centerAlignX = true
          mutate = true

        default:
          break
      }
    }

    // Based on the options supplied, choose the right layout size for calls
    // to systemLayoutSizeFitting()
    let kLayoutSize = layoutCompressed
      ? UIView.layoutFittingCompressedSize
      : UIView.layoutFittingExpandedSize

    // Based on the options, we might need to temporarily disable some the
    // applied constraints. If so, filter out only the currently active ones
    let enabledConstraints = disableConstraints && self.constraints.count > 0
      ? self.constraints.filter { (c) -> Bool in return c.isActive }
      : []

    // If we need to disable constraints to calculate the size, do so now
    if disableConstraints {
      NSLayoutConstraint.deactivate(enabledConstraints)
    }

    // If we are mutating the width, lets do that here
    if resizeWidth { self.width = width }

    // If we are mutating the x coordinte, we can determine the values here
    if leftAlignX { self.x = 0 }
    else if rightAlignX { self.x = width - self.width }
    else if centerAlignX { self.x = (width / 2) - (self.width / 2) }

    // Before we run through the list, adjust our height to be zero
    // in the case that elements have been removed previously
    var calculatedHeight: CGFloat = padStart

    // Check to see if there is an intrinsicContentSize specified first
    if self.intrinsicContentSize.height != UIView.noIntrinsicMetric {
      calculatedHeight += self.height
    }

    // Secondly, if there isn't one, try for a systemLayoutSizeFitting the
    // specified layout size (either compressed or expanded)
    else {
      let curHeight: CGFloat = self.height
      let autoFlags = self.translatesAutoresizingMaskIntoConstraints
      var height: CGFloat = 0

      self.translatesAutoresizingMaskIntoConstraints = true
      self.height = 0
      height = self.systemLayoutSizeFitting(kLayoutSize).height

      // If the last line results in a height equal to the layout size constant
      // then we got no workable value from the function; try falling back to
      // sizeThatFits() since this often reliable function existed before the
      // introduction of AutoLayout.
      if (height == kLayoutSize.height) {
        let curHeight = self.height

        self.height = 0
        height = self.sizeThatFits(UIView.layoutFittingCompressedSize).height
        self.height = curHeight

        calculatedHeight += height
      }

      // Otherwise take the value calulated by systemLayoutSizeFitting(:)
      else {
        calculatedHeight += height
      }

      self.translatesAutoresizingMaskIntoConstraints = autoFlags
      self.height = curHeight
    }

    // To finish our calculation of height, add any supplied end padding
    calculatedHeight += padEnd

    // In order to determine what value to return, we need to capture the
    // current view's reported height
    let setSize = self.height

    // We also need to calculate the subviews cumulative height if the options
    // specify to do so. Since this can be more costly, we set it to -1 and
    // short circuit if the option is not present.
    let subviewSum = preferSubviewSize
      ? self.calculateSubviewsHeight(
          0, padPerSubview, 0, opts.except(opts: .preferSubviewSum)
        )
      : -1

    // If we previously disabled the constraints, we need to reenable them.
    if disableConstraints {
      NSLayoutConstraint.activate(enabledConstraints)
    }

    /// If we have mutated any values, we need to set the dirty flags for
    /// this view so that it will be attended to.
    if mutate {
      if self.constraints.count > 0 {
        self.setNeedsUpdateConstraints()
      }
      self.setNeedsLayout()
      self.setNeedsDisplay()
    }

    // The caller can specify that all values are preferred. In such cases,
    // we return either the minimum or maximum of the three possible values
    // based on whether or not minimumOfChoices is requested
    if preferSetSize && preferSubviewSize {
      if useMin { return min(min(setSize, calculatedHeight), subviewSum) }
      else { return max(max(setSize, calculatedHeight), subviewSum) }
    }

    // If only a preference for subview size is supplied, then the calculated
    // height or the subview sizes are compared and constrasted. If the
    // minimumOfChoices options is specified the minimum of the two will be
    // returned; otherwise the maximum will be.
    if preferSubviewSize {
      if useMin { return min(calculatedHeight, subviewSum) }
      else { return max(calculatedHeight, subviewSum) }
    }

    // If only a preference for the set size is supplied, then the calculated
    // height or the set sizes are compared and constrasted. If the
    // minimumOfChoices options is specified the minimum of the two will be
    // returned; otherwise the maximum will be.
    if preferSetSize {
      if useMin { return min(calculatedHeight, setSize) }
      else { return max(calculatedHeight, setSize) }
    }

    // If there is no preferred size, the calculated size alone will be
    // returned.
    return calculatedHeight
  }


  /**
    Walks through the subviews and calculates a total height, with an optional
    pre or post padding, and returns the value. The actual height of the view
    or its subviews are not modified.

    - Parameters:
      - padStart: any padding to be applied to the starting height
      - padPerView: any padding applied between each view
      - padEnd: and padding to be applied to the ending height
      - opts: an array of enum values denoting the configuration of this
        calculation
    - Returns:
      a CGFloat denoting the calculated height
   */
  public func calculateSubviewsHeight(
    _ padStart: CGFloat = 0,
    _ padPerView: CGFloat = 0,
    _ padEnd: CGFloat = 0,
    _ opts: [UIViewSizingOpts] = .Defaults
  ) -> CGFloat {
    // Before we run through the list, adjust our height to be zero
    // in the case that elements have been removed previously
    var calculatedHeight: CGFloat = padStart
    let stackY: Bool = opts.contains(.mutateYByStackingVertically)
    let useY: Bool = opts.contains(.includeYOffset)

    for view in self.subviews {
      if stackY { view.y = calculatedHeight }

      calculatedHeight += useY ? view.y : 0
      calculatedHeight += view.calculateOwnHeight(
        padStart,
        padEnd,
        padPerView,
        opts
      )

      if stackY {
        if stackY {
          if view.constraints.count > 0 {
            view.setNeedsUpdateConstraints()
          }

          view.setNeedsLayout()
          view.setNeedsDisplay()
        }
      }
    }

    return calculatedHeight + padEnd
  }

  /**
    Rather than forcing the user to walk an array in order to calculate and
    tally heights, this function will do so for them.

    - Parameters:
      - views: the array of views to walk
      - padStart: any padding to be applied to the starting height
      - padPerView: any padding applied between each view
      - padEnd: and padding to be applied to the ending height
      - opts: an array of enum values denoting the configuration of this
        calculation
    - Returns:
      a CGFloat denoting the calculated height
   */
  public static func calculateHeightOf(
    _ views: [UIView],
    _ padStart: CGFloat = 0,
    _ padPerView: CGFloat = 0,
    _ padEnd: CGFloat = 0,
    _ opts: [UIViewSizingOpts] = .Defaults
  ) -> CGFloat {
    let stackY: Bool = opts.contains(.mutateYByStackingVertically)
    var height: CGFloat = padStart

    for view in views {
      if stackY { view.y = height }

      height += view.calculateOwnHeight(0, 0, 0, opts) + padPerView

      if stackY {
        if view.constraints.count > 0 {
          view.setNeedsUpdateConstraints()
        }

        view.setNeedsLayout()
        view.setNeedsDisplay()
      }
    }

    // Since we always adding per view padding, remove the last amount
    height -= padPerView

    // Add any traililng padding
    height += padEnd

    return height
  }
}
