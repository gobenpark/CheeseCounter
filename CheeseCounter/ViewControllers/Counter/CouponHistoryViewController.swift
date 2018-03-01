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
  
  let datas = Variable<[CouponHistoryViewModel]>([])
  let couponClick = Variable<CouponHistoryViewModel.Item?>(nil)
  
  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<CouponHistoryViewModel>(configureCell: {ds,cv,idx,item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: CouponHistoryCell.self), for: idx) as! CouponHistoryCell
    cell.model = item
    cell.viewController = self
    return cell
  })
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(CouponHistoryCell.self, forCellWithReuseIdentifier: String(describing: CouponHistoryCell.self))
    collectionView.alwaysBounceVertical = true
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    view = collectionView
    
    datas.asDriver()
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    CheeseService.provider.request(.getMyCouponList)
      .filter(statusCode: 200)
      .map(GiftListModel.self)
      .map{[CouponHistoryViewModel(items: $0.result.data)]}
      .asObservable()
      .bind(to: datas)
      .disposed(by: disposeBag)
    
    CheeseService.provider.request(.getMyCouponList)
      .filter(statusCode: 200)
      .mapJSON()
      .subscribe(onSuccess: { (response) in
        log.info(response)
      }) { (error) in
        log.error(error)
      }.disposed(by: disposeBag)
    
    couponClick.asDriver()
      .filterNil()
      .drive(onNext: {[weak self] (data) in
        self?.navigationController?.pushViewController(CouponDownViewController(model: data), animated: true)
      }).disposed(by: disposeBag)
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "쿠폰내역")
  }
}
