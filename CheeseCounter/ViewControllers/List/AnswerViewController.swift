//
//  AnswerViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 19..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxCocoa
import RxSwift
import RxDataSources
import Moya

class AnswerViewController: BaseListViewController, IndicatorInfoProvider{
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.register(AnswerViewCell.self, forCellWithReuseIdentifier: "cell")
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
      .debug()
      .scan(datas.value){ (state, viewModel) in
        return state + viewModel
      }.bind(to: datas)
      .disposed(by: disposeBag)
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "응답")
  }
}
