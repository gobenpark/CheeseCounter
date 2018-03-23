//
//  HistoryViewController.swift
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

final class HistoryViewController: UIViewController, IndicatorInfoProvider{
  
  let disposeBag = DisposeBag()
  let provider = MoyaProvider<CheeseCounter>().rx
  let dataSources = RxCollectionViewSectionedReloadDataSource<HistoryViewModel>(configureCell: {(ds,cv,idx,item) in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: HistoryViewCell.self), for: idx) as! HistoryViewCell
    cell.item = item
    return cell
  })
  let datas = Variable<[HistoryViewModel]>([])
  let calendarView = CalendarSelectView()
  var isLoading: Bool = false {
    didSet{
      collectionView.reloadEmptyDataSet()
    }
  }
  
  let activityView: UIActivityIndicatorView = {
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    activityView.frame = UIScreen.main.bounds
    return activityView
  }()
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 10
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 70)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = #colorLiteral(red: 0.9567790627, green: 0.9569162726, blue: 0.956749022, alpha: 1)
    collectionView.emptyDataSetSource = self
    collectionView.register(HistoryViewCell.self
      , forCellWithReuseIdentifier: String(describing: HistoryViewCell.self))
    collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 44, right: 0)
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(calendarView)
    view.addSubview(collectionView)
    
    calendarView.fetchData = {[weak self] date in
      self?.request(date: date)
    }
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    addConstraint()
  }
  
  private func request(date: [String: String]){
    let year = date["year",default: "0"]
    let month = date["month",default: "0"]
    
    
    log.info(year)
    log.info(month)
    provider.request(.getMyPointHistory(type: "cheese", year: year, month: month))
      .map(HistoryModel.self)
      .map{[HistoryViewModel(items: $0.result.data)]}
      .asObservable()
      .bind(to: datas)
      .disposed(by: disposeBag)
  }
  
  private func addConstraint(){
    
    calendarView.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(82)
    }
    
    collectionView.snp.makeConstraints { (make) in
      make.top.equalTo(calendarView.snp.bottom)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "적립내역")
  }
}

extension HistoryViewController: DZNEmptyDataSetSource{
  
  func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
    let label = UILabel()
    label.textAlignment = .center
    label.attributedText = NSAttributedString(string: "골드를 구입하시면 질문의 응답률이 높아져요."
      , attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15)
        ,NSAttributedStringKey.foregroundColor:UIColor.gray])
    
    self.activityView.startAnimating()
    
    if isLoading{
      return activityView
    }else{
      return label
    }
  }
  
  func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
    return #colorLiteral(red: 0.9489366412, green: 0.9490727782, blue: 0.9489067197, alpha: 1)
  }
}

