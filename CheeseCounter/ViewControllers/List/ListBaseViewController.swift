//
//  ListBaseViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 21..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Moya

enum RequestAction{
  case reload
  case paging(String)
}

class BaseListViewController: UIViewController{
  
  public let provider = CheeseService.provider
  public let disposeBag = DisposeBag()
  public let datas = Variable<[CheeseViewModel]>([])
  public let dataSources = RxCollectionViewSectionedReloadDataSource<CheeseViewModel>(configureCell:{ds ,cv ,idx, item in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: "cell", for: idx) as! BaseListViewCell
    cell.model = item
    return cell
  })
  public let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 120)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.alwaysBounceVertical = true
    collectionView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
    collectionView.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 44, right: 0)
    return collectionView
  }()
  
  let refreshView = UIRefreshControl()

  override func loadView() {
    view = collectionView
    
    collectionView.addSubview(refreshView)    
    refreshView.rx
      .controlEvent(.valueChanged)
      .subscribe({[weak self] (_) in
        self?.request(requestType: .reload)
      }).disposed(by: disposeBag)
    
    collectionView.rx
      .willEndDragging
      .map {$0.0}
      .asDriver(onErrorJustReturn: .zero)
      .drive(onNext: navigationHidden)
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
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                 withVelocity velocity: CGPoint,
                                 targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    
    let contentOffsetBottom = scrollView.contentOffset.y + scrollView.frame.height
    let didReachBottom = scrollView.contentSize.height > 0
      && contentOffsetBottom >= scrollView.contentSize.height - 300
    if didReachBottom{
      request(requestType: .paging(dataSources.sectionModels.last?.items.last?.id ?? String()))
    }
  }
  open func request(requestType: RequestAction){}
}
