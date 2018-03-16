//
//  ShopViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 22..
//  Copyright © 2018년 xiilab. All rights reserved.
//  치즈로 구매하기 페이지

import UIKit
import XLPagerTabStrip
import RxSwift
import RxCocoa
import RxDataSources
import SwiftyJSON

final class ShopViewController: UIViewController, IndicatorInfoProvider{
  
  let provider = CheeseService.provider
  let disposeBag = DisposeBag()
  let dataSubject = BehaviorSubject<[GiftViewModel]>(value: [])
  private var currentCheese: Int = 0
  
  let dataSources = RxCollectionViewSectionedReloadDataSource<GiftViewModel>(configureCell:{ (ds, cv, idx, item) -> UICollectionViewCell in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: GiftItemViewCell.self), for: idx) as! GiftItemViewCell
    cell.item = item
    cell.cheeseButton.isHidden = false
    return cell
  },configureSupplementaryView:{ds,cv,name,idx in
    let view = cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                   withReuseIdentifier: String(describing: CounterCollectionHeaderView.self),
                                                   for: idx) as! CounterCollectionHeaderView
    return view
  })
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/2)
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 60)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(GiftItemViewCell.self, forCellWithReuseIdentifier: String(describing: GiftItemViewCell.self))
    collectionView.register(CounterCollectionHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                            withReuseIdentifier: String(describing: CounterCollectionHeaderView.self))
//    collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 44, right: 0)
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    CheeseService.provider.request(.getMyPoint)
      .filter(statusCode: 200)
      .mapJSON()
      .map{JSON($0)}
      .subscribe(onSuccess: { [weak self] (json) in
        self?.currentCheese = json["result"]["data"]["cheese"].intValue
      }) { (error) in
        log.error(error)
      }.disposed(by: disposeBag)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    
    provider.request(.getGiftList)
      .map(GiftModel.self)
      .map {[GiftViewModel(items: $0.result.data)]}
      .asObservable()
      .bind(to: dataSubject)
      .disposed(by: disposeBag)
    
    dataSubject.asDriver(onErrorJustReturn: [])
      .drive(collectionView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    collectionView.rx.willEndDragging
      .map{$0.0}
      .asDriver(onErrorJustReturn: .zero)
      .drive(onNext: navigationHidden)
      .disposed(by: disposeBag)
    
    collectionView.rx
      .itemSelected
      .bind(onNext: selectedItem)
      .disposed(by: disposeBag)
  }
  
  func navigationHidden(point: CGPoint){
    if point.y > 0{
      UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
      }, completion: nil)
    }else{
      UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
      }, completion: nil)
    }
  }
  
  func selectedItem(item: IndexPath){
    let model = dataSources.sectionModels.first?.items[item.item]
    guard model?.coupon_count != nil && model?.coupon_count != "0" else {return}
    guard guardCheeseCount(cheese: model?.buyPoint ?? String()) else {return}
    self.navigationController?.pushViewController(ShopDetailViewController(model: model), animated: true)
  }
  
  private func guardCheeseCount(cheese: String) -> Bool{
    guard let intCheese = Int(cheese) else {return false}
    return currentCheese >= intCheese
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "쇼핑")
  }
}
