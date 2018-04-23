////
////  WinnerView.swift
////  CheeseCounter
////
////  Created by xiilab on 2018. 4. 17..
////  Copyright © 2018년 xiilab. All rights reserved.
////
//
//import RxSwift
//import RxCocoa
//import RxDataSources
//
//class WinnerView: UICollectionView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//  
//  private var timer: Disposable?
//  private var direction: UICollectionViewScrollDirection = .horizontal
////  var lastItem: WinListModel.Result.Data?
//  var a: UICollectionViewScrollToEndDelegate?
//  
//  init(direction: UICollectionViewScrollDirection) {
//    let layout = UICollectionViewFlowLayout()
//    self.direction = direction
//    layout.scrollDirection = direction
//    
//    super.init(frame: .zero, collectionViewLayout: layout)
//    
//    self.delegate = self
//    self.backgroundColor = .clear
//    self.isUserInteractionEnabled = false
//  }
//  
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    return CGSize(width: self.frame.width, height: 50)
//  }
//  
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  
//  func startAutoScroll() {
//    if timer != nil {
//      return
//    }
//
//    timer = Observable<Int>.interval(3, scheduler: MainScheduler.instance)
//      .subscribe(onNext: { [weak self] _ in
//        guard let `self` = self else { return }
//        log.info("startAutoScroll")
//        let itemCount = self.numberOfItems(inSection: 0)
//        var currentIndexPath = self.indexPathsForVisibleItems[0]
//        //        log.info(itemCount)
//
//        if self.indexPathsForVisibleItems.count == 0 || itemCount <= 1 {
//          self.a?.collectionViewScrollToEnd(count: itemCount)
//          self.stopAutoScroll()
//          return
//        }
//        
//        if self.direction == .horizontal {
//          if currentIndexPath.item == itemCount - 2 {
//            let nextIndexPath = IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section)
//            self.scrollToItem(at: nextIndexPath, at: .left, animated: true)
//
////            self.lastItem = self.dataSource.value[0].
//            
//            self.a?.collectionViewScrollToEnd(count: itemCount)
//            self.stopAutoScroll()
////          } else if currentIndexPath.item == itemCount - 1 {
////            log.info("last Count")
////                        self.stopAutoScroll()
//
//            //            var nextIndexPath = IndexPath(item: 0, section: currentIndexPath.section)
//            //            self.scrollToItem(at: nextIndexPath, at: .left, animated: false)
//            //            nextIndexPath = IndexPath(item: 1, section: currentIndexPath.section)
//            //            self.scrollToItem(at: nextIndexPath, at: .left, animated: true)
//          }
//          else {
//            let nextIndexPath = IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section)
//            self.scrollToItem(at: nextIndexPath, at: .left, animated: true)
//          }
//        }
//        }, onError: {(err) in log.error(err)})
//  }
//  
//  func stopAutoScroll() {
//    timer?.dispose()
//    timer = nil
//    log.info("stop!!!!")
//  }
//  
//  func resetScrollPosition() {
//    if self.numberOfSections > 0 && self.numberOfItems(inSection: 0) > 0 {
//      scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
//    }
//  }
//}
