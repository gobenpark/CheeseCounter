//
//  CurrentCheeseViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 19..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import Spring

class CurrentCheeseViewController: CurrentBaseViewController{
  
  
  override func setUp(){
    
    collectionView.dataSource = self
    collectionView.register(CurrentCheeseViewCell.self, forCellWithReuseIdentifier: CurrentCheeseViewCell.ID)
    collectionView.register(CheeseRankView.self, forCellWithReuseIdentifier: CheeseRankView.ID)
    counterMenuBar = CounterMenuBar(menuString: ["치즈 내역","치즈 랭킹"], frame: .zero)
    counterMenuBar.currentViewController = self
    
    self.view.addSubview(counterMenuBar)
    
    counterMenuBar.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.top.equalToSuperview()
      make.height.equalToSuperview().dividedBy(9)
    }
    
    collectionView.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.top.equalTo(counterMenuBar.snp.bottom)
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
  
  override func scrollToMenuIndex(_ menuIndex: Int) {
    super.scrollToMenuIndex(menuIndex)
    if menuIndex == 1{
      collectionView.reloadItems(at: [IndexPath(item: menuIndex, section: 0)])
    }
  }


  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? CurrentCheeseViewCell{
      cell.calendarView.emptyTextView.endEditing(true)
    }
    
    let index = targetContentOffset.pointee.x / view.frame.width
    let indexPath = IndexPath(item: Int(index), section: 0)
    counterMenuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
    }
}

extension CurrentCheeseViewController: UICollectionViewDataSource{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView
    ,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    switch indexPath.item {
    case 0:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentCheeseViewCell.ID, for: indexPath) as! CurrentCheeseViewCell
      return cell
    case 1:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheeseRankView.ID, for: indexPath) as! CheeseRankView
      cell.fetchData()
      return cell
    default:
      break
    }
    return UICollectionViewCell()
  }
}

