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

class BaseListViewController: UIViewController{
  
  public let provider = MoyaProvider<CheeseCounter>().rx
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
    collectionView.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 44, right: 0)
    return collectionView
  }()

  override func loadView() {
    view = collectionView
    collectionView.rx.itemSelected
      .map {[unowned self] idx in self.datas.value[idx.section].items[idx.item]}
      .subscribe (onNext:{ [weak self] (data) in
        guard let `self` = self else {return}
        self.navigationController?.pushViewController(ReplyViewController(model: data), animated: true)
    }).disposed(by: disposeBag)
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                 withVelocity velocity: CGPoint,
                                 targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    
    let contentOffsetBottom = scrollView.contentOffset.y + scrollView.frame.height
    let didReachBottom = scrollView.contentSize.height > 0
      && contentOffsetBottom >= scrollView.contentSize.height - 300
    if didReachBottom{
      request(pageNum: dataSources.sectionModels.last?.items.last?.id ?? String())
    }
  }
  
  open func request(pageNum: String){}
}
