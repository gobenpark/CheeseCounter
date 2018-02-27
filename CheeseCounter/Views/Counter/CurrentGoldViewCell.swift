//
//  CurrentTableViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 13..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import DZNEmptyDataSet

class CurrentGoldViewCell: UICollectionViewCell{
  
  static let ID = "CurrentGoldViewCell"
  
  let calendarView = CalendarSelectView()
  var historyData: [HistoryData.Data]?
  var isLoading: Bool = false {
    didSet{
      collectionView.reloadEmptyDataSet()
      setNeedsLayout()
    }
  }
  
  let activityView: UIActivityIndicatorView = {
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    activityView.frame = UIScreen.main.bounds
    return activityView
  }()
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 10
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = #colorLiteral(red: 0.9567790627, green: 0.9569162726, blue: 0.956749022, alpha: 1)
    collectionView.delegate = self
//    collectionView.dataSource = self
    collectionView.emptyDataSetSource = self
    collectionView.emptyDataSetDelegate = self
//    collectionView.register(CurrentListViewCellofCell.self
//      , forCellWithReuseIdentifier: CurrentListViewCellofCell.ID)
    collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 44, right: 0)
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(collectionView)
    contentView.addSubview(calendarView)
    calendarView.fetchData = fetch(parameter:)
    
    calendarView.snp.makeConstraints{ (make) in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(70)
    }
    
    collectionView.snp.makeConstraints { (make) in
      make.top.equalTo(calendarView.snp.bottom)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
 
  func fetch(parameter:[String:String]){
    isLoading = true
    var parameter = parameter
    parameter["type"] = "gold"
    PointService.getMyPointHistory(parameter: parameter) {[weak self] (response) in
      guard let `self` = self else {return}
      switch response.result{
      case .success(let value):
        self.historyData = value.data
        self.collectionView.reloadData()
      case .failure(let error):
        log.error(error.localizedDescription)
      }
      self.isLoading = false
    }
  }
}

//extension CurrentGoldViewCell: UICollectionViewDataSource {
//  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return historyData?.count ?? 0
//  }
//
//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentListViewCellofCell.ID, for: indexPath) as! CurrentListViewCellofCell
//    cell.fetchData(data: historyData?[indexPath.item])
//    return cell
//  }
//}

extension CurrentGoldViewCell: UICollectionViewDelegate{
  
}


extension CurrentGoldViewCell: DZNEmptyDataSetSource{
  
  func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
    let label = UILabel()
    label.textAlignment = .center
    label.attributedText = NSAttributedString(string: "골드를 구입하시면 질문의 응답률이 높아져요."
      , attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15)
        ,NSAttributedStringKey.foregroundColor:UIColor.gray])
    
    self.activityView.startAnimating()
    
    if isLoading{
      return activityView
    }else{
      return label
    }
  }
  
  func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
    return #colorLiteral(red: 0.9489366412, green: 0.9490727782, blue: 0.9489067197, alpha: 1)
  }
}

extension CurrentGoldViewCell: DZNEmptyDataSetDelegate{
  
}
extension CurrentGoldViewCell: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.frame.width, height: 70)
  }
}

