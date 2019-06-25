//
//  ViewController.swift
//  LeftRightView
//
//  Created by Harrison, Brielle on 6/24/19.
//  Copyright © 2019 Harrison, Brielle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet var lrView: LeftRightView?
  @IBOutlet var outer: LeftRightView?
  @IBOutlet var lineItem: LeftRightView?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    if
      let lrView = lrView,
      let lineItem = lineItem,
      let outer = outer
    {
      lrView.insets = .init(top: 5, left: 5, bottom: 5, right: 5)
      lineItem.insets = .init(top: 5, left: 5, bottom: 5, right: 5)
      outer.insets = .init(top: 0, left: 5, bottom: 0, right: 0)
    }
  }


}

