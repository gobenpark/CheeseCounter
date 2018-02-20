//
//  CurrentCheeseViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 19..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import DZNEmptyDataSet

class CurrentCheeseViewCell: UICollectionViewCell{
  
  static let ID = "CurrentCheeseViewCell"
  
  let calendarView = CalendarSelectView()
  var historyData: [HistoryData.Data]?
  var isLoading: Bool = false {
    didSet{
      collectionView.reloadEmptyDataSet()
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
    collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 44, right: 0)
    collectionView.backgroundColor = #colorLiteral(red: 0.9567790627, green: 0.9569162726, blue: 0.956749022, alpha: 1)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.emptyDataSetSource = self
    collectionView.emptyDataSetDelegate = self
//    collectionView.register(CurrentListViewCellofCell.self, forCellWithReuseIdentifier: CurrentListViewCellofCell.ID)
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(collectionView)
    addSubview(calendarView)
    calendarView.snp.remakeConstraints{ (make) in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(72)
    }
    
    collectionView.snp.remakeConstraints { (make) in
      make.top.equalTo(calendarView.snp.bottom)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    backgroundColor = .white
    calendarView.fetchData = fetch(parameter:)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  func fetch(parameter:[String:String]){
    self.isLoading = true
    var parameter = parameter
    parameter["type"] = "cheese"
    PointService.getMyPointHistory(parameter: parameter) { (response) in
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

extension CurrentCheeseViewCell: UICollectionViewDelegate{
  
}

extension CurrentCheeseViewCell: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return historyData?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(), for: indexPath)
    
    return cell
  }
}

extension CurrentCheeseViewCell: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.frame.width, height: 70)
  }
}

extension CurrentCheeseViewCell: DZNEmptyDataSetSource{
  
  func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
    let label = UILabel()
    label.textAlignment = .center
    label.attributedText = NSAttributedString(string: "질문에 응답하고 치즈를 적립하세요."
      , attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15)
        ,NSAttributedStringKey.foregroundColor:UIColor.gray])
    activityView.startAnimating()
    
    if isLoading{
        return activityView
    }else{
      return label
    }
  }
  
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    let text = "프리미엄질문에 응답하시면 치즈를 얻을 수 있습니다."
    let attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor:UIColor.gray]
    return NSAttributedString(string: text, attributes: attributes)
  }
  
  func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
    return #colorLiteral(red: 0.9489366412, green: 0.9490727782, blue: 0.9489067197, alpha: 1)
  }
}

extension CurrentCheeseViewCell: DZNEmptyDataSetDelegate{
  
}
