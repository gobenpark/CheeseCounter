//
//  LevelAlertView.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 5. 15..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import SwiftMessages

class TwoButtonMessageView: MessageView {
  
  @IBOutlet weak var myPageViewButton: UIButton? {
    didSet {
      if let old = oldValue {
        old.removeTarget(self, action: #selector(myPageViewButtonTapped), for: .touchUpInside)
      }
      if let button = myPageViewButton {
        button.addTarget(self, action: #selector(myPageViewButtonTapped), for: .touchUpInside)
      }
    }
  }
  
  var myPageViewButtonTapHandler: ((_ button: UIButton) -> Void)?
  
  @objc func myPageViewButtonTapped(_ button: UIButton) {
    myPageViewButtonTapHandler?(button)
  }
}
