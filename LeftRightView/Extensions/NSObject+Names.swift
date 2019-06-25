//
//  NSObject+Names.swift
//  NativeCheckout
//
//  Created by Harrison, Brielle on 6/5/19.
//  Copyright © 2019 com.paypal.checkout. All rights reserved.
//

import Foundation

extension NSObject {
  public static var className: String {
    return NSStringFromClass(self)
  }
}

