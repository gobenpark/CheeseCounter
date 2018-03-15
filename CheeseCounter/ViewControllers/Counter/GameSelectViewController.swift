//
//  SampleViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 19..
//  Copyright © 2018년 xiilab. All rights reserved.
//  게임으로 구매하기 페이지

import XLPagerTabStrip
import RxSwift
import RxCocoa
import RxDataSources
import Moya
import RxOptional
import DZNEmptyDataSet

protocol SelectProvider {
  func navigationHidden(point: CGPoint)
}

class GameSelectViewController: UIViewController, IndicatorInfoProvider{
  
  let provider = MoyaProvider<CheeseCounter>().rx
  let disposeBag = DisposeBag()
  let dataSubject = BehaviorSubject<[GiftViewModel]>(value: [])
  
  private let dataSources = RxCollectionViewSectionedReloadDataSource<GiftViewModel>(configureCell:{ (ds, cv, idx, item) -> UICollectionViewCell in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: GiftItemViewCell.self), for: idx) as! GiftItemViewCell
    cell.item = item
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view = collectionView
    
    request()
    
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
  
  private func request(){
    provider.request(.getGiftList)
      .map(GiftModel.self)
      .map {[GiftViewModel(items: $0.result.data)]}
      .asObservable()
      .bind(to: dataSubject)
      .disposed(by: disposeBag)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    request()
  }
  
  func selectedItem(item: IndexPath){
    let images = [#imageLiteral(resourceName: "cheeseBrie"),#imageLiteral(resourceName: "cheeseFeta"),#imageLiteral(resourceName: "cheeseBrick"),#imageLiteral(resourceName: "cheeseGauda"),#imageLiteral(resourceName: "cheeseBrie2"),#imageLiteral(resourceName: "cheeseBrie2"),#imageLiteral(resourceName: "cheeseGorgonzola")]
    
    if let model = dataSources.sectionModels.first?.items[item.item]{
      guard model.coupon_count != nil && model.coupon_count != "0" else {return}
      self.navigationController?.pushViewController(GameViewController(images: images, model: model), animated: true)
    }
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


  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "게임")
  }
}
