//
//  Dictionary+Concat.swift
//  PayPalCheckout
//
//  Created by Harrison, Brielle on 4/12/19.
//  Copyright © 2019 com.paypal.checkout. All rights reserved.
//

import Foundation

extension Dictionary {
  /**
   An operator overload allowing two dictionaries to be concatenated
   to one another using the plus operator. Note that this operation
   currently creates a third dictionary containing first the contents
   of the dictionary on the left, followed by the contents of the
   dictionary on the right. If any of the keys in the right hand side
   dictionary match those of the left, the value is overwritten using
   the value from the right hand dictionary.

   Parameters:
   - lhs: The left hand dictionary
   - rhs: The right hand dictionary to add in

   Returns: the modified left hand operand with the values from the
   right hand operand added in.
   */
  static func + <Key, Value> (
    lhs: [Key: Value],
    rhs: [Key: Value]
  ) -> [Key: Value] {
    var result = [Key:Value]()

    lhs.forEach { result[$0] = $1 }
    rhs.forEach { result[$0] = $1 }

    return result
  }
}
