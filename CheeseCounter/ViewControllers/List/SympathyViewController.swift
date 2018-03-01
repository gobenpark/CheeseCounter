//
//  SympathyViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 19..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SympathyViewController: BaseListViewController, IndicatorInfoProvider{
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.register(EmptyListViewCell.self, forCellWithReuseIdentifier: "cell")
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    request(pageNum: "0")
  }
  
  override func request(pageNum: String) {
    provider.request(.getMyAnswerSurveyList(pageNum: pageNum))
      .filter(statusCode: 200)
      .map(MainSurveyList.self)
      .map{[CheeseViewModel(items: $0.result.data)]}
      .asObservable()
      .scan(datas.value){ (state, viewModel) in
        return state + viewModel
      }.bind(to: datas)
      .disposed(by: disposeBag)
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "공감")
  }
}
