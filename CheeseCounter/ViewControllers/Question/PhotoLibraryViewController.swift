//
//  PhotoLibraryViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 3. 19..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import TLPhotoPicker
import XLPagerTabStrip

extension TLPhotosPickerViewController: IndicatorInfoProvider{
  public func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "갤러리")
  }
}
