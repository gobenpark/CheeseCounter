//
//  ReplyListViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 19..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ReplyListViewController: UIViewController, IndicatorInfoProvider{
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "댓글")
  }
}
