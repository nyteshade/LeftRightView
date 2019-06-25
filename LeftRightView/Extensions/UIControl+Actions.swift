//
//  UIControl+Actions.swift
//  NativeCheckout
//
//  Created by Harrison, Brielle on 5/14/19.
//  Copyright © 2019 com.paypal.checkout. All rights reserved.
//

import UIKit

public typealias ActionClosureWrapperFn = (UIControl?)->()
public typealias GestureClosureWrapperFn = (UIGestureRecognizer?)->()

/**
 ActionClosureSleeve wraps a closure that takes a UIGestureRecognizer. The
 instance is associated with the UIView when added and will be deallocated
 when the associated object goes out of scope.
 */
@objc public class ActionClosureWrapper: NSObject {
  public let closure: ActionClosureWrapperFn

  public init (_ closure: @escaping ActionClosureWrapperFn) {
    self.closure = closure
    super.init()
  }

  @objc public func invoke(_ sender: UIControl) {
    closure(sender)
  }

  public var selector: Selector {
    return #selector(ActionClosureWrapper.invoke(_:))
  }
}

/**
  GestureClosureSleeve wraps a closure that takes a UIGestureRecognizer. The
  instance is associated with the UIView when added and will be deallocated
  when the associated object goes out of scope.
 */
@objc public class GestureClosureWrapper: NSObject {
  public let closure: GestureClosureWrapperFn

  public init (_ closure: @escaping GestureClosureWrapperFn) {
    self.closure = closure
    super.init()
  }

  @objc public func invoke(_ sender: UIGestureRecognizer) {
    closure(sender)
  }

  public var selector: Selector {
    return #selector(GestureClosureWrapper.invoke(_:))
  }
}

extension UIControl {
  /**
    Adds an action listener to any UIControl on which this function is
    invoked. The supplied closure will be executed rather than having
    to write a function and point it at that class via a selector. A closure
    is returned that, if executed, will remove the target from the object.

    - Parameters:
      - for: type of UIControl.Event to add a target for
      - closure: the closure that takes a UIControl when the action occurs
    - Returns: a closure that when executed, removes the added action.
   */
  func addAction(
    for controlEvents: UIControl.Event = .touchUpInside,
    _ closure: @escaping ActionClosureWrapperFn
  ) {
    let wrapper = ActionClosureWrapper(closure)
    let key = "[\(arc4random()).\(String(describing: controlEvents))]"

    addTarget(wrapper, action: wrapper.selector, for: controlEvents)
    objc_setAssociatedObject(
      self, key, wrapper,
      objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
    )
  }
}

/**
  To add support for adding a closure based gesture recognizer, we need to
  know a few things about the type of recognizer you wish as well as how to
  link it up to the GestureClosureSleeve.
 */
public enum UIViewGestureType {
  /// Declares and configures a UITapGestureRecognizer (numTaps, numTouches)
  /// - numTaps: The number of taps for the gesture to be recognized.
  /// - numTouches: The number of fingers required to tap for the gesture to
  ///   be recognized.
  case tap(_ numTaps: Int, _ numTouches: Int)

  /// Declares a UIPinchGestureRecognizer
  case pinch

  /// Declares a UIRotationGestureRecogniåzer
  case rotation

  /// Declares a UISwipeGestureRecognizer (direction, numTouches)
  /// - direction: The permitted direction of the swipe for this gesture
  ///   recognizer.
  /// - numTouches: The number of touches that must be present for the swipe
  ///   gesture to be recognized.
  case swipe(_ direction: UISwipeGestureRecognizer.Direction, _ numTouches: Int)

  /// Declares and configures a UIPanGestureRecognizer (minTouches, maxTouches)
  /// - minTouches: The minimum number of fingers that can be touching the view
  ///   for this gesture to be recognized.
  /// - maxTouches: The maximum number of fingers that can be touching the
  ///   view for this gesture to be recognized.
  case pan(_ minTouches: Int, _ maxTouches: Int)

  /// Declares and configures a UIScreenEdgePanGestureRecognizer (edges)
  /// - edges: The acceptable starting edges for the gesture.
  case edge(_ edges: UIRectEdge)

  /// Declares and configures a UILongPressGestureRecognizer
  /// - minPressDuration: The minimum period fingers must press on the view
  ///   for the gesture to be recognized.
  /// - numTouchesReq: The number of fingers that must be pressed on the view
  ///   for the gesture to be recognized.
  /// - numTapsReq: The number of taps on the view required for the gesture
  ///   to be recognized.
  /// - allowableMovement: The maximum movement of the fingers on the view
  ///   before the gesture fails.
  case longPress(
    _ minPressDuration: TimeInterval,
    _ numTouchesReq: Int,
    _ numTapsReq: Int,
    _ allowableMovement: CGFloat
  )

  /// If you have already declared, created and configured a custom recognizer
  /// use the custom type and pass your recognizer as the parameter
  /// - gesture: an instance of UIGestureRecognizer to use instead
  case custom(_ gesture: UIGestureRecognizer)
}

extension UIView {
  /**
    Adds a gesture recognizer to any UIView, easily, that takes a closure which
    receives the recognizer in question when invoked. This function also sets
    the user interaction enabled flag to true

    - Parameters:
      - gestureType: the type of recognizer to add a recognizer for
      - closure: the code that executes when the gesture happens

    - Returns: the closure function returned will remove the added recognizer
      when invoked.
   */
  func addGesture(
    _ gestureType: UIViewGestureType,
    _ closure: @escaping GestureClosureWrapperFn
  ) {
    let wrapper = GestureClosureWrapper(closure)
    let key = "[\(arc4random()).\(String(describing: gestureType))]"
    var gesture: UIGestureRecognizer

    self.isUserInteractionEnabled = true

    switch gestureType {
      case .tap(let numTaps, let numTouches):
        let g = UITapGestureRecognizer(
          target: wrapper,
          action: wrapper.selector
        )
        g.numberOfTapsRequired = numTaps
        g.numberOfTouchesRequired = numTouches
        gesture = g
        break

      case .pinch:
        gesture = UIPinchGestureRecognizer(
          target: wrapper,
          action: wrapper.selector
        )
        break

      case .rotation:
        gesture = UIRotationGestureRecognizer(
          target: wrapper,
          action: wrapper.selector
        )
        break

      case .swipe(let dir, let numberOfTouches):
        let g = UISwipeGestureRecognizer(
          target: wrapper,
          action: wrapper.selector
        )
        g.direction = dir
        g.numberOfTouchesRequired = numberOfTouches
        gesture = g
        break

      case .pan(let minTouches, let maxTouches):
        let g = UIPanGestureRecognizer(
          target: wrapper,
          action: wrapper.selector
        )
        g.minimumNumberOfTouches = minTouches
        g.maximumNumberOfTouches = maxTouches
        gesture = g
        break

      case .edge(let edges):
        let g = UIScreenEdgePanGestureRecognizer(
          target: wrapper,
          action: wrapper.selector
        )
        g.edges = edges
        gesture = g
        break

      case .longPress(
        let minDuration,
        let numTouchesRequired,
        let numTapsRequired,
        let allowableMovement
      ):
        let g = UILongPressGestureRecognizer(
          target: wrapper,
          action: wrapper.selector
        )
        g.minimumPressDuration = minDuration
        g.numberOfTouchesRequired = numTouchesRequired
        g.numberOfTapsRequired = numTapsRequired
        g.allowableMovement = allowableMovement
        gesture = g

        break

      case .custom(let recognizer):
        gesture = recognizer
        gesture.addTarget(wrapper, action: wrapper.selector)
        break
    }

    addGestureRecognizer(gesture)
    objc_setAssociatedObject(
      self, key, wrapper,
      objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
    )
  }
}

///**
//  An object to wrap and store the closure that is being referenced directly
//  by the call to addAction()
// */
//class Target {
//  private let target: (NSObject?) -> ()
//
//  init(target: @escaping (NSObject?) -> ()) {
//    self.target = target
//  }
//
//  @objc private func invoke(sender: NSObject?) {
//    target(sender)
//  }
//
//  public var selector: Selector {
//    return #selector(invoke(sender:))
//  }
//}
//
//protocol PropertyProvider {
//  associatedtype PropertyType: Any
//
//  static var property: PropertyType { get set }
//}
//
//protocol ExtensionPropertyStorable: class {
//  associatedtype Property: PropertyProvider
//}
//
//extension ExtensionPropertyStorable {
//  typealias Storable = Property.PropertyType
//
//  var property: Storable {
//    get {
//      return objc_getAssociatedObject(
//        self,
//        String(describing: type(of: Storable.self))
//      ) as? Storable ?? Property.property
//    }
//
//    set {
//      return objc_setAssociatedObject(
//        self,
//        String(describing: type(of: Storable.self)),
//        newValue,
//        .OBJC_ASSOCIATION_RETAIN
//      )
//    }
//  }
//}
//
//extension UIControl: ExtensionPropertyStorable {
//
//  class Property: PropertyProvider {
//    static var property = [String: Target]()
//  }
//
//  func addTarget(
//    for controlEvent: UIControl.Event = .touchUpInside,
//    target: @escaping (NSObject?) ->()
//  ) {
//    let key = String(describing: controlEvent)
//    let target = Target(target: target)
//
//    addTarget(target, action: target.selector, for: controlEvent)
//    property[key] = target
//  }
//
//  func removeTarget(for controlEvent: UIControl.Event = .touchUpInside) {
//    let key = String(describing: controlEvent)
//    let target = property[key]
//
//    removeTarget(target, action: target?.selector, for: controlEvent)
//    property[key] = nil
//  }
//}
//
//extension UIGestureRecognizer: ExtensionPropertyStorable {
//
//  class Property: PropertyProvider {
//    static var property: Target?
//  }
//
//  func addTarget(target: @escaping (NSObject?) -> ()) {
//    let target = Target(target: target)
//
//    addTarget(target, action: target.selector)
//    property = target
//  }
//
//  func removeTarget() {
//    let target = property
//
//    removeTarget(target, action: target?.selector)
//    property = nil
//  }
//}
