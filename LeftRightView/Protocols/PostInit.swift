//
//  PostInit.swift
//  NativeCheckout
//
//  Created by Harrison, Brielle on 5/2/19.
//  Copyright © 2019 com.paypal.checkout. All rights reserved.
//

import UIKit

protocol PostInit {
  /**
   Simple post initializer that is to be invoked in any conforming
   class or struct.
   */
  func postInit() -> Void
}

/// An alias to the no param no return type post initializer function that
/// is used in the PostInits protocol
public typealias PostInitializerFn = () -> ()

/**
  A wrapper that will be appended to any NSObject class that invokes the
  addPostInit() method. This initializer will be invoked, alongside any
  of its peers, whenever postInits() is invoked.

  Each wrapper is designed to hold a single instance of PostInitializerFn
 */
@objc public class PostInitializerWrapper: NSObject {
  /// The closure instance to wrap
  public let closure: PostInitializerFn

  /**
    This initializer takes a closure to wrap as a post initializer

    - Parameters:
      - fn: the closure to add to the list of post initializers to execute
   */
  public init(_ fn: @escaping PostInitializerFn) {
    closure = fn
    super.init()
  }

  /// Calls the wrapped closure/function
  @objc public func invoke() { closure() }

  /// A selector that points to the function's invoke method
  public var selector: Selector {
    return #selector(PostInitializerWrapper.invoke)
  }
}

/**
  Unlike PostInit which requires that the conforming class define a single
  method with the name postInit() that takes no parameters and returns no
  values, PostInits in turn allows you to add n-number of closures that will
  be called when postInits() is called.

  Additionally, if the postInits() is called and the class also conforms to
  PostInit(), then postInit() will be called first.
 */
protocol PostInits {
  /// Storage must be provided for the post initializer wrappers
  var initializers: [PostInitializerWrapper] { get set }

  /**
    Given a post initializer function, this function should wrap the value
    in a PostInitializerWrapper object and add it to the internal initalizers
    array

    - Parameters:
      - fn: the function to add to the internal intiailzers array; this
        function will be called whenver postInits() is called.
   */
  mutating func addPostInit(_ fn: @escaping PostInitializerFn)

  /**
    This function is expected to walk through the initialzers array and
    invoke the PostInitializerFn for each stored wrapper in the list.
   */
  func postInits() -> Void
}

/**
  This extension adds PostInits protocol conformance to every instance of
  NSObject. The initializers array is handled using associated objects and
  the postInits and addPostInit methods work as expected for a default
  implementation.
 */
extension NSObject: PostInits {
  /**
    The getter will retrieve the associated array of wrappers and, if there
    is no list yet generated, it will generate and store that value before
    returning it. Alternatively, you may set the associated object directly
    and any subsequent call to get will use the newly set value.
   */
  internal var initializers: [PostInitializerWrapper] {
    get {
      let key = "\(ObjectIdentifier(self))PostInitializerStore"

      if
        let storage = objc_getAssociatedObject(self, key)
          as? [PostInitializerWrapper]
      {
        return storage
      }

      let store = [PostInitializerWrapper]()

      self.initializers = store
      
      return store
    }
    
    set {
      let key = "\(ObjectIdentifier(self))PostInitializerStore"
  
      objc_setAssociatedObject(
        self, key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
      )
    }
  }

  /**
    As a default implementation, this function takes an initializer function
    and addes it to the internal initiailzer list.

    - Parameters:
      - fn: an instance of a closure or function to call when postInits() is
        invoked.
   */
  func addPostInit(_ fn: @escaping PostInitializerFn) {
    let wrapper = PostInitializerWrapper(fn)
    
    initializers.append(wrapper)
  }

  /**
    Invokes all the post initializer functions added via calls to addPostInit.
    If the object also happens to conform to PostInit, that handler will be
    called before the internal list of initializers for legacy purposes.
   */
  func postInits() {
    if let postIniter = self as? PostInit {
      postIniter.postInit()
    }

    for wrapper in initializers {
      wrapper.invoke()
    }
  }
}
