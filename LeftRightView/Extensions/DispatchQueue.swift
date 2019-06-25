//
//  DispatchQueue.swift
//  NativeCheckout
//
//  Created by Harrison, Brielle on 5/6/19.
//  Copyright © 2019 com.paypal.checkout. All rights reserved.
//

import Foundation

extension DispatchQueue {
  /**
    There is an error that gets thrown if DispatchQueue.main.sync { } is
    executed if the current thread is the main thread. This solves that
    issue by checking first and simply executing if we are in the main
    thread or sending it off to DispatchQueue.main.sync otherwise.

    - Parameters:
      - execute: the closure/block to execute on the main thread
   */
  public static func mainSync(_ execute: () -> Void) {
    if Thread.isMainThread {
      execute()
    }
    else {
      DispatchQueue.main.sync(execute: execute)
    }
  }
}
