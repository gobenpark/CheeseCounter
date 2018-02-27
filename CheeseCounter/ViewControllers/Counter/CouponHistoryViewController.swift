//
//  CouponHistoryViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 5..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import RxCocoa
import RxDataSources

final class CouponHistoryViewController: UIViewController, IndicatorInfoProvider{
  
  let disposeBag = DisposeBag()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "쿠폰내역")
  }
}
