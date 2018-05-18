//
//  WinViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 4. 12..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import SwiftyJSON
import Moya
import DZNEmptyDataSet


class WinViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
  
  let provider = CheeseService.provider
  let disposeBag = DisposeBag()
  let dataSubject = BehaviorRelay<[WinViewModel]>(value: [])
  var timer: Disposable?
  var page = 0
  
  private let dataSources = RxCollectionViewSectionedReloadDataSource<WinViewModel>(configureCell: { (ds, cv, idx, item) -> UICollectionViewCell in
    let cell = cv.dequeueReusableCell(withReuseIdentifier: String(describing: WinViewCell.self), for: idx) as! WinViewCell
    cell.model = item
    return cell
  })
  
  lazy var winnerView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(WinViewCell.self, forCellWithReuseIdentifier: String(describing: WinViewCell.self))
    collectionView.delegate = self
    collectionView.isUserInteractionEnabled = false
    collectionView.alwaysBounceVertical = true
    collectionView.backgroundColor = .white
    
    return collectionView
  }()
  
  func requestReloadWithDelay(onlyItem: Bool) {
//    log.info("request reload delay")
    if onlyItem {
      Observable<Int>.timer(10, scheduler: MainScheduler.instance)
        .subscribe(onCompleted: {
          self.requestReload()
        })
        .disposed(by: disposeBag)
    } else {
      Observable<Int>.timer(0.2, scheduler: MainScheduler.instance)
        .subscribe(onCompleted: {
          self.requestReload()
        })
        .disposed(by: disposeBag)
    }
  }
  
  func requestReload() {
//    log.info("request reload")
    var retryCount = 3
    provider.request(.getWinList)
      .filter(statusCode: 200)
      .map(WinListModel.self)
      .map{ (model) in
        var items = [WinListModel.Result.Data]()
        if self.dataSources.sectionModels.count > 0 {
          let itemCount = self.dataSources.sectionModels[0].items.count
          let lastItem = self.dataSources.sectionModels[0].items[itemCount - 1]
          if itemCount != 1 {
            items.append(lastItem)
          }
        }
        items.append(contentsOf: model.result.data)
        return [WinViewModel(items: items)]
      }
      .asObservable()
      .do(onNext: { _ in
        if self.dataSources.sectionModels.count > 0 &&
          self.dataSources.sectionModels[0].items.count > 0 {
          self.winnerView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        }
      }, onCompleted: {
        self.startTimer(resetPage: true)
      })
      .retryWhen{ (errorObservable: Observable<Error>) in
        return errorObservable.flatMap({ (err) -> Observable<Int> in
          if retryCount > 0 {
            retryCount -= 1
            return Observable<Int>.timer(3, scheduler: MainScheduler.instance)
          } else {
            return Observable<Int>.error(err)
          }
        })}
      .catchErrorJustReturn([WinViewModel(items: [])])
      .filter({ return $0[0].items.count > 0 })
      .bind(to: dataSubject)
      .disposed(by: disposeBag)
  }
  
  func startTimer(resetPage: Bool = false) {
//    log.info("start Timer")
   
    if timer != nil {
      return
    }
    if resetPage {
      page = 0
    }
    timer = Observable<Int>
      .interval(3, scheduler: MainScheduler.instance)
      .subscribe(onNext: {_ in
         
        if self.winnerView.numberOfSections == 0 {
          self.stopTimer()
          return
        }
        
        let itemCount = self.winnerView.numberOfItems(inSection: 0)
        
        if itemCount == 0 {
          self.stopTimer()
          return
        }
        
        if self.page < itemCount - 1 {
          self.page += 1
          self.winnerView.scrollToItem(at: IndexPath(item: self.page, section: 0), at: .left, animated: true)
        }
        
        if self.page == itemCount - 1 {
          self.stopTimer()
          self.requestReloadWithDelay(onlyItem: (itemCount == 1))
        }
        
        if self.page < 0 || self.page >= itemCount {
          self.stopTimer()
        }
      }, onError: { (err) in
        log.error(err)
      })
  }
  
  func stopTimer(){
//    log.info("stop Timer")
    timer?.dispose()
    timer = nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSubject.asDriver(onErrorJustReturn: [])
      .drive(self.winnerView.rx.items(dataSource: dataSources))
      .disposed(by: disposeBag)
    
    startTimer(resetPage: true)
    requestReload()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    startTimer()
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.winnerView.frame.width, height: 50)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    stopTimer()
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
