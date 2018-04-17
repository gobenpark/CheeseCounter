//
//  WinViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 4. 12..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwiftyJSON
import Moya
import DZNEmptyDataSet

class WinViewController: UIViewController {
  
  let provider = CheeseService.provider
  let disposeBag = DisposeBag()
  let dataSubject = BehaviorRelay<[WinViewModel]>(value: [])
  
  private let dataSources = RxCollectionViewSectionedReloadDataSource<WinViewModel>(configureCell: { (ds, cv, idx, item) -> UICollectionViewCell in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: WinViewCell.self), for: idx) as! WinViewCell
    cell.model = item
    return cell
  })
  
  lazy var winnerView: WinnerView = {
    let view = WinnerView(direction: .horizontal)
    view.register(WinViewCell.self, forCellWithReuseIdentifier: String(describing: WinViewCell.self))
    return view
  }()
  
  public func initView() {
    requestWinList()
    
    dataSubject.asDriver(onErrorJustReturn: [])
      .drive(winnerView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
  }
  
  public func requestWinList() {
    provider.request(.getWinList)
      .filter(statusCode: 200)
      .map(WinListModel.self)
      .map{
        var items = [WinListModel.Result.Data]()
        items.append(contentsOf: $0.result.data)
        if items.count > 1 {
          items.append(items[0])
        }
        return [WinViewModel(items: items)]
      }
      .asObservable()
      .bind(to: dataSubject)
      .disposed(by: disposeBag)
  }
}

extension WinViewController: DZNEmptyDataSetSource {
  func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.attributedText = NSAttributedString(string: "게임에 도전해보세요!"
      , attributes: [NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 11)
        ,NSAttributedStringKey.foregroundColor:UIColor.gray])
    
    return label
  }
}

class WinnerView: UICollectionView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  private var timer: Disposable? = nil
  private var direction: UICollectionViewScrollDirection = .horizontal
  
  init(direction: UICollectionViewScrollDirection) {
    let layout = UICollectionViewFlowLayout()
    self.direction = direction
    layout.scrollDirection = direction
    
    super.init(frame: .zero, collectionViewLayout: layout)
    
    self.delegate = self
    self.backgroundColor = .clear
    self.isUserInteractionEnabled = false
  }
  
//  deinit {
//    timer?.dispose()
//    timer = nil
//  }
//
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.frame.width, height: 50)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func startAutoScroll() {
    //    self.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
    timer = Observable<Int>.interval(3, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        guard let `self` = self else { return }
        //        log.info("startAutoScroll")
        let itemCount = self.numberOfItems(inSection: 0)
        
        if self.indexPathsForVisibleItems.count == 0 || itemCount <= 1 {
          return
        }
        
        var currentIndexPath = self.indexPathsForVisibleItems[0]
        if self.direction == .horizontal {
          if currentIndexPath.item == itemCount - 1 {
            var nextIndexPath = IndexPath(item: 0, section: currentIndexPath.section)
            self.scrollToItem(at: nextIndexPath, at: .left, animated: false)
            
            nextIndexPath = IndexPath(item: 1, section: currentIndexPath.section)
            self.scrollToItem(at: nextIndexPath, at: .left, animated: true)
          } else {
            let nextIndexPath = IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section)
            self.scrollToItem(at: nextIndexPath, at: .left, animated: true)
          }
        }
        }, onError: {(err) in log.error(err)})
  }
  
  func stopAutoScroll() {
    timer?.dispose()
    timer = nil
    //    log.info("stop!!!!")
  }
}


