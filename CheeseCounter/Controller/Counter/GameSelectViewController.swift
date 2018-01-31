//
//  SampleViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 19..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import XLPagerTabStrip
import RxSwift
import RxCocoa
import RxDataSources
import Moya
import RxOptional

protocol SelectProvider {
  func navigationHidden(point: CGPoint)
}


class GameSelectViewController: UIViewController, IndicatorInfoProvider{
  
  let provider = MoyaProvider<CheeseCounter>().rx
  let disposeBag = DisposeBag()
  let dataSubject = BehaviorSubject<[GiftViewModel]>(value: [])
  
  let dataSources = RxCollectionViewSectionedReloadDataSource<GiftViewModel>(configureCell:{ (ds, cv, idx, item) -> UICollectionViewCell in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: GiftItemViewCell.self), for: idx) as! GiftItemViewCell
    cell.item = item
    return cell
  })
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/2)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(GiftItemViewCell.self, forCellWithReuseIdentifier: String(describing: GiftItemViewCell.self))
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()
  
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
  
  func selectedItem(item: IndexPath){
    let images = [#imageLiteral(resourceName: "cheeseBrie"),#imageLiteral(resourceName: "cheeseFeta"),#imageLiteral(resourceName: "cheeseBrick"),#imageLiteral(resourceName: "cheeseGauda"),#imageLiteral(resourceName: "cheeseBrie2"),#imageLiteral(resourceName: "cheeseBrie2")]
    if let model = dataSources.sectionModels.first?.items[item.item]{
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
