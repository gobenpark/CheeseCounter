//
//  RankViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 2..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import XLPagerTabStrip
import DZNEmptyDataSet
import Moya


class RankViewController: UIViewController, IndicatorInfoProvider{
  
  let provider = MoyaProvider<CheeseCounter>().rx
  let disposeBag = DisposeBag()
  let data = BehaviorSubject<[RankViewModel]>(value: [])
  let dataSources = RxCollectionViewSectionedReloadDataSource<RankViewModel>(
    configureCell: {(ds,cv,ip,item) in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: CheeseRankViewCell.self), for: ip) as! CheeseRankViewCell
    cell.item = item
    return cell
  },configureSupplementaryView:{ (ds,cv,item,ip) in
    let view = cv.dequeueReusableSupplementaryView(
      ofKind: UICollectionElementKindSectionHeader,
      withReuseIdentifier: String(describing: CheeseRankReuseView.self),
      for: ip) as! CheeseRankReuseView
    return view
  })
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 76)
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 30)
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 2
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    collectionView.emptyDataSetSource = self
    collectionView.alwaysBounceVertical = true
    collectionView.register(CheeseRankReuseView.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                            withReuseIdentifier: String(describing: CheeseRankReuseView.self))
    collectionView.register(CheeseRankViewCell.self,
                            forCellWithReuseIdentifier: String(describing: CheeseRankViewCell.self))
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view = collectionView
    
    provider.request(.getTopRankList)
      .map(RankModel.self)
      .map{$0.result.data}
      .map{[RankViewModel(header: "Top 100", items: $0)]}
      .asObservable()
      .bind(to: data)
      .disposed(by: disposeBag)
    
    data.asDriver(onErrorJustReturn: [])
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "랭킹")
  }
}

extension RankViewController: DZNEmptyDataSetSource{
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "아직 순위가 없어요"
      , attributes: [NSAttributedStringKey.foregroundColor:UIColor.lightGray,NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 18)])
  }
}
