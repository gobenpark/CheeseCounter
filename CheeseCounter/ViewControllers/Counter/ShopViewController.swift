//
//  ShopViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 22..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import XLPagerTabStrip

final class ShopViewController: GameSelectViewController{
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func selectedItem(item: IndexPath){
    let model = dataSources.sectionModels.first?.items[item.item]
    self.navigationController?.pushViewController(ShopDetailViewController(model: model), animated: true)
  }
  
  override func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "쇼핑")
  }
}

