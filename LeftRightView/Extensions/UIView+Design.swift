//
//  UIView+RoundCorners.swift
//  PayPalCheckout
//
//  Created by Ali, Kaniz on 4/24/19.
//  Copyright © 2019 com.paypal.checkout. All rights reserved.
//
import UIKit

public extension UIView {

  /**
   A function that will round the corners of a UIView

   Higher input = rounder view.You could use this to create a full circle

   - Parameters:
     - cornerRadius: the desired radius of the UIView

   - Returns: Void

   - Requires:
     - A _Double_
     - To be used on a UIView
   */
  func roundCorners(cornerRadius: Double) {
    self.layer.cornerRadius = CGFloat(cornerRadius)
    self.clipsToBounds = true
  }
  
  /**
   A function that will animate a fade-in for a UIView

   - Parameters:
     - duration: the desired time for the animation
     - withAlpha: the desired alpha (1 is full color)

   - Returns: Void

   - Requires:
     - A _TimeInterval_
     - A _CGFloat_
     - To be used on a UIView
   */
  func fadeIn(duration: TimeInterval = 2.0, withAlpha alpha: CGFloat) {
    UIView.animate(withDuration: duration, animations: {
      self.alpha = alpha
    })
  }
}

/**
  Provides some sequenced animation routines to the UIView class. Other
  related functions should appear here in this extension as well.
 */
extension UIView {
  /**
    The problem with UIView.animate and UIView.animateKeyFrames is that
    they do not allow for code to be executed between each sequenced
    animation. Due to the way that most of the basic animation libraries
    work, there is a contrived limit to the number of linked animations
    that can be performed.

    This extension allows up to four animations and completion blocks to
    be chained in order. The first has to complete before the second
    starts, and so on.

    - Parameters:
      - duration1: the `TimeInterval` length of the animation for animation 1
      - options1: the `UIView.AnimationOptions` for animation 1
      - animation1: the final state afte the animation is complete for anim 1
      - completion1: the code to execute after animation 1 is complete
      - duration2: the `TimeInterval` length of the animation for animation 2
      - options2: the `UIView.AnimationOptions` for animation 2
      - animation2: the final state afte the animation is complete for anim 2
      - completion2: the code to execute after animation 2 is complete
      - duration3: the `TimeInterval` length of the animation for animation 3
      - options3: the `UIView.AnimationOptions` for animation 3
      - animation3: the final state afte the animation is complete for anim 3
      - completion3: the code to execute after animation 3 is complete
      - duration4: the `TimeInterval` length of the animation for animation 4
      - options4: the `UIView.AnimationOptions` for animation 4
      - animation4: the final state afte the animation is complete for anim 4
      - completion4: the code to execute after animation 4 is complete
   */
  public static func animations(
    _ duration1: TimeInterval,
    _ options1:  UIView.AnimationOptions,
    _ animation1: @escaping (() -> Void),
    _ completion1: ((Bool) -> Void)? = nil,
    _ duration2: TimeInterval? = nil,
    _ options2:  UIView.AnimationOptions? = nil,
    _ animation2: @escaping (() -> Void) = { },
    _ completion2: ((Bool) -> Void)? = nil,
    _ duration3: TimeInterval? = nil,
    _ options3:  UIView.AnimationOptions? = nil,
    _ animation3: @escaping (() -> Void) = { },
    _ completion3: ((Bool) -> Void)? = nil,
    _ duration4: TimeInterval? = nil,
    _ options4:  UIView.AnimationOptions? = nil,
    _ animation4: @escaping (() -> Void) = { },
    _ completion4: ((Bool) -> Void)? = nil
  ) {
    UIView.animate(
      withDuration: duration1,
      delay: 0,
      options: options1,
      animations: animation1,
      completion: {
        ok in

        if let completion1 = completion1 {
          completion1(ok)
        }

        if
          let duration2 = duration2,
          let options2 = options2
        {
          UIView.animate(
            withDuration: duration2,
            delay: 0,
            options: options2,
            animations: animation2,
            completion: {
              ok in

              if let completion2 = completion2 {
                completion2(ok)
              }

              if
                let duration3 = duration3,
                let options3 = options3
              {
                UIView.animate(
                  withDuration: duration3,
                  delay: 0,
                  options: options3,
                  animations: animation3,
                  completion: {
                    ok in
                    if let completion3 = completion3 {
                      completion3(ok)
                    }

                    if
                      let duration4 = duration4,
                      let options4 = options4
                    {
                      UIView.animate(
                        withDuration: duration4,
                        delay: 0,
                        options: options4,
                        animations: animation4,
                        completion: {
                          ok in
                          if let completion4 = completion4 {
                            completion4(ok)
                          }
                        }
                      )
                    }
                  }
                )
              }
            }
          )
        }
      }
    )
  }
}
