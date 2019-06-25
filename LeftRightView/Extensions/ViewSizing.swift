//
//  ViewSizing.swift
//  NativeCheckout
//
//  Created by Harrison, Brielle on 5/2/19.
//  Copyright © 2019 com.paypal.checkout. All rights reserved.
//

import UIKit

extension UIView {
  /**
    Property extension that retrieves the x coordinate from the
    UIView's `frame.origin`. When set, a new CGRect with the new value
    is used. All other values are maintained as they were.
   */
  @objc public var x: CGFloat {
    get { return self.frame.origin.x }
    set {
      self.frame = CGRect(
        origin: CGPoint(x: newValue, y: self.frame.origin.y),
        size: self.frame.size
      )
    }
  }

  /**
    Property extension that retrieves the y coordinate from the
    UIView's `frame.origin`. When set, a new CGRect with the new value
    is used. All other values are maintained as they were.
   */
  @objc public var y: CGFloat {
    get { return self.frame.origin.y }
    set {
      self.frame = CGRect(
        origin: CGPoint(x: self.frame.origin.x, y: newValue),
        size: self.frame.size
      )
    }
  }

  /**
   This property when gotten is a two value tuple with the frame's origin's
   x and y values. When set, it receives a two value tuple with the same
   values and uses them to create a new CGPoint. The new point and existing
   size are used to make a new CGRect value for the view's frame.
   */
  public var xy: (CGFloat, CGFloat) {
    get { return (self.frame.origin.x, self.frame.origin.y) }
    set {
      self.frame = CGRect(
        origin: CGPoint(x: newValue.0, y: newValue.1),
        size: self.frame.size
      )
    }
  }

  /**
    Property extension that retrieves the width value from the
    UIView's `frame.size`. When set, a new CGRect with the new value
    is used. All other values are maintained as they were.
   */
  @objc public var width: CGFloat {
    get { return self.frame.size.width }
    set {
      self.frame = CGRect(
        origin: self.frame.origin,
        size: CGSize(width: newValue, height: self.frame.size.height)
      )
    }
  }

  /**
    Property extension that retrieves the height value from the
    UIView's `frame.size`. When set, a new CGRect with the new value
    is used. All other values are maintained as they were.
   */
  @objc public var height: CGFloat {
    get { return self.frame.size.height }
    set {
      self.frame = CGRect(
        origin: self.frame.origin,
        size: CGSize(width: self.frame.size.width, height: newValue)
      )
    }
  }

  /**
    This property when gotten is a two value tuple with the frame's size's
    width and height values. When set, it receives a two value tuple with
    the same values and uses them to create a new CGSize. The new point
    and existing origin are used to make a new CGRect value for the
    view's frame.
   */
  public var wh: (CGFloat, CGFloat) {
    get { return (self.frame.size.width, self.frame.size.height) }
    set {
      self.frame = CGRect(
        origin: self.frame.origin,
        size: CGSize(width: newValue.0, height: newValue.1)
      )
    }
  }

  /**
    Much as the extended properties xy and wh represent the origin and size
    of a views frame, this property returns and sets all those values in a
    single tuple with four values. In order, those values are x, y, width and
    height.
   */
  public var xywh: (CGFloat, CGFloat, CGFloat, CGFloat) {
    get {
      return (
        frame.origin.x, frame.origin.y, frame.size.width, frame.size.height
      )
    }
    set {
      self.frame = CGRect(
        x: newValue.0, y: newValue.1, width: newValue.2, height: newValue.3
      )
    }
  }

  /**
    A shorthand property that retrieves the view's size property from its
    frame. Setting the value causes a new CGRect with the existing origin
    and the newly supplied size.
   */
  @objc public var size: CGSize {
    get { return self.frame.size }
    set {
      self.frame = CGRect(
        origin: self.frame.origin,
        size: newValue
      )
    }
  }

  /**
   A shorthand property that retrieves the view's origin property from its
   frame. Setting the value causes a new CGRect with the existing size
   and the newly supplied origin.
   */
  @objc public var origin: CGPoint {
    get { return self.frame.origin }
    set {
      self.frame = CGRect(
        origin: newValue,
        size: self.frame.size
      )
    }
  }

  /**
    A function that alters the internal x and y coordinate by adding the
    supplied x and y values to what the view already records. If those
    numbers are negative, then the values will be diminished through the
    simple process of mathematics.

    - Parameters:
      - x: the x value to add to the existing x value
      - y: the y value to add to the existing y value
    - Returns:
      an instance to itself so the function can be inlined.
   */
  @objc @discardableResult public func moveBy(
    _ x: CGFloat,
    _ y: CGFloat = 0
  ) -> UIView {
    self.xy = (self.x + x, self.y + y)

    return self
  }

  /**
    A function that alters the internal width and height coordinate by adding
    the supplied width and height values to what the view already records.
    If those numbers are negative, then the values will be diminished through
    the simple process of mathematics.

    - Parameters:
      - w: the width value to add to the existing width value
      - h: the height value to add to the existing height value
    - Returns:
      an instance to itself so the function can be inlined.
   */
  @objc @discardableResult public func growBy(
    _ w: CGFloat,
    _ h: CGFloat = 0
  ) -> UIView {
    self.wh = (self.width + w, self.height + h)

    return self
  }

  /**
    A function that alters the existing frame values by those supplied as
    parameters. Positive numbers will increase the existing values and negative
    numbers will decrease them, as expected.

    - Parameters:
      - x: the x value to add to the existing x value
      - y: the y value to add to the existing y value
      - w: the width value to add to the existing width value
      - h: the height value to add to the existing height value
    - Returns:
      an instance to itself so the function can be inlined.
   */
  @objc @discardableResult public func translate(
    _ x: CGFloat = 0,
    _ y: CGFloat = 0,
    _ w: CGFloat = 0,
    _ h: CGFloat = 0
    ) -> UIView {
    self.xywh = (
      self.x + x,
      self.y + y,
      self.width + w,
      self.height + h
    )

    return self
  }
}

extension CGRect {
  /// Returns the x coordinate of the immutable rectangle
  public var x: CGFloat {
    get { return self.origin.x }
  }

  /// Returns the y coordinate of the immutable rectangle
  public var y: CGFloat {
    get { return self.origin.y }
  }

  /// Returns the width of the immutable rectangle
  public var width: CGFloat {
    get { return self.size.width }
  }

  /// Returns the height of the immutable reectangle
  public var height: CGFloat {
    get { return self.size.height }
  }

  /**
    Given a rectangle of values, this function will return another CGRect
    that shares the same size as the one this is called on but with a modified
    point. This function will center the view on the whole page.

    - Returns: a CGRect with a modified x coordinate
   */
  public func centerWidth(_ within: CGFloat? = nil) -> CGRect {
    let screenW = within ?? CGFloat.ScreenWidth
    let x = (screenW / 2) - (self.size.width / 2)

    return CGRect(x: x, y: self.y, width: self.width, height: self.height)
  }

  /**
    Given a rectangle of values, this function will return another CGRect
    that shares the same size as the one this is called on but with a modified
    point. This function will center the view on the whole page.

    - Returns: a CGRect with a modified x coordinate
   */
  public func centerHeight(_ within: CGFloat? = nil) -> CGRect {
    let screenH = within ?? CGFloat.ScreenHeight
    let y = (screenH / 2) - (self.size.height / 2)

    return CGRect(x: self.x, y: y, width: self.width, height: self.height)
  }

  /**
    Increases or decreases the internal origin of the given CGRect by adding
    the supplied x and y values to the existing ones. A new CGPoint is made
    and combined with the existing size to make a new CGRect which is returned

    - Parameters:
      - x: the x coordinate delta to add
      - y: the y coordinate delta to add
    - Returns:
      a new CGRect with the new origin and existing size
   */
  @discardableResult public func moveBy(
    _ x: CGFloat,
    _ y: CGFloat = 0
  ) -> CGRect {
    return CGRect(
      origin: origin.moveBy(x,y),
      size: size
    )
  }

  /**
    Increases or decreases the internal size of the given CGRect by adding
    the supplied w and h values to the existing ones. A new CGSize is made
    and combined with the existing origin to make a new CGRect which is
    returned

    - Parameters:
      - w: the width delta to add
      - h: the height delta to add
    - Returns:
      a new CGRect with the new origin and existing size
   */
  @discardableResult public func growBy(
    _ w: CGFloat,
    _ h: CGFloat = 0
  ) -> CGRect {
    return CGRect(
      origin: origin,
      size: size.growBy(w, h)
    )
  }

  /**
    A function that alters the existing frame values by those supplied as
    parameters. Positive numbers will increase the existing values and negative
    numbers will decrease them, as expected.

    - Parameters:
      - x: the x value to add to the existing x value
      - y: the y value to add to the existing y value
      - w: the width value to add to the existing width value
      - h: the height value to add to the existing height value
    - Returns:
      a new CGRect, modified by the supplied deltas
   */
  @discardableResult public func translate(
    _ x: CGFloat = 0,
    _ y: CGFloat = 0,
    _ w: CGFloat = 0,
    _ h: CGFloat = 0
  ) -> CGRect {
    return CGRect(
      x: x + origin.x,
      y: y + origin.y,
      width: w + size.width,
      height: h + size.height
    )
  }

  /**
   This property when gotten is a two value tuple with the frame's origin's
   x and y values. When set, it receives a two value tuple with the same
   values and uses them to create a new CGPoint. The new point and existing
   size are used to make a new CGRect value for the view's frame.
   */
  public var xy: (CGFloat, CGFloat) {
    get { return (origin.x, origin.y) }
  }

  /**
    This property when gotten is a two value tuple with the frame's size's
    width and height values. The new point and existing origin are used to
    make a new CGRect value for the view's frame.
   */
  public var wh: (CGFloat, CGFloat) {
    get { return (size.width, size.height) }
  }

  /**
    Much as the extended properties xy and wh represent the origin and size
    of a views frame, this property returns all those values in a
    single tuple with four values. In order, those values are x, y, width and
    height.
   */
  public var xywh: (CGFloat, CGFloat, CGFloat, CGFloat) {
    get {
      return (
        origin.x, origin.y, size.width, size.height
      )
    }
  }

}

extension CGPoint {
  /**
   Increases or decreases the internal x and y coordinates by adding
   the supplied x and y values to the existing ones.

   - Parameters:
     - x: the x coordinate delta to add
     - y: the y coordinate delta to add
   - Returns:
    a new CGPoint with the new origin
   */
  @discardableResult public func moveBy(
    _ x: CGFloat,
    _ y: CGFloat = 0
  ) -> CGPoint {
    return CGPoint(x: self.x + x, y: self.y + y)
  }

  /**
    This property when gotten is a two value tuple with the point's x and
    y values.
   */
  public var xy: (CGFloat, CGFloat) {
    get { return (x, y) }
  }
}

extension CGSize {
  /**
   This property when gotten is a two value tuple with the size's
   width and height values.
   */
  public var wh: (CGFloat, CGFloat) {
    get { return (width, height) }
  }

  /**
    Increases or decreases the internal size of the given CGRect by adding
    the supplied w and h values to the existing ones. A new CGSize is made
    and combined with the existing origin to make a new CGRect which is
    returned

    - Parameters:
      - w: the width delta to add
      - h: the height delta to add
    - Returns:
      a new CGRect with the new origin and existing size
   */
  @discardableResult public func growBy(
    _ w: CGFloat,
    _ h: CGFloat = 0
  ) -> CGSize {
    return CGSize(width: self.width + w, height: self.height + h)
  }

  /**
    Applies the current UIScreen width and uses it instead in conjunction
    with the instance's height value.

    - Returns: a CGSize instance with the same height and screen width
   */
  public func applyScreenWidth() -> CGSize {
    return CGSize(width: .ScreenWidth, height: self.height)
  }

  /**
   Applies the current UIScreen height and uses it instead in conjunction
   with the instance's width value.

   - Returns: a CGSize instance with the same width and screen height
   */
  public func applyScreenHeight() -> CGSize {
    return CGSize(width: self.width, height: .ScreenHeight)
  }

  /**
    Creates a CGSize struct with the width set to the dynamic screen width
    and the height set to whatever is supplied.

    - Parameters:
      - height: the specified height

    - Returns: a CGSize instance with full screen width and specified height
   */
  public static func screenWidthBy(_ height: CGFloat) -> CGSize {
    return CGSize(
      width: .ScreenWidth,
      height: height
    )
  }

  /**
   Creates a CGSize struct with the height set to the dynamic screen height
   and the width set to whatever is supplied.

   - Parameters:
     - width: the specified height

   - Returns: a CGSize instance with full screen height and specified width
   */
  public static func screenHeightBy(_ width: CGFloat) -> CGSize {
    return CGSize(
      width: width,
      height: .ScreenHeight
    )
  }

}
