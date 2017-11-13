//
//  sampleViewCell.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 3. 4..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout
import Hero


final class CheeseViewCell: UITableViewCell
{
  var isPremium: Bool?
  var date:String?
  var currentIndex:Int?
  var cheeseData: [CheeseResultByDate.Data] = []{
    didSet{
      self.carouselView.reloadData()
    }
  }
  
  var isLoading: Bool = false
  let dateLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 15)
    label.textColor = .black
    label.textAlignment = .center
    label.backgroundColor = UIColor.rgb(red: 254, green: 215, blue: 2)
    return label
  }()
  
  
  lazy var carouselView : UICollectionView = {
    let layout = UPCarouselFlowLayout()
    layout.scrollDirection = .horizontal
    layout.spacingMode = .overlap(visibleOffset: 50)
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.65)
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    if #available(iOS 10.0, *){
      cv.isPrefetchingEnabled = false
    }
    cv.showsHorizontalScrollIndicator = false
    cv.backgroundColor = .white
    cv.alwaysBounceHorizontal = true
    return cv
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.selectionStyle = .none
    
//    self.heroID = "CheeseViewCell"
    
  
    self.contentView.addSubview(carouselView)
    self.contentView.addSubview(dateLabel)
    backgroundColor = UIColor.cheeseColor()
    carouselView.register(CarouselCell2.self, forCellWithReuseIdentifier: String(describing: CarouselCell2.self))
    carouselView.register(CarouselCell4.self, forCellWithReuseIdentifier: String(describing: CarouselCell4.self))
    carouselView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    addConstraint()
  }
  
  fileprivate func loadSurveyType(data: CheeseDataSet){
    switch data.dateType{
    case .ordinary(let dateString):
      self.dateLabel.text = dateString
      self.isPremium = false
    case .premium:
      self.dateLabel.text = "유료질문"
      self.isPremium = true
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    dateLabel.layer.cornerRadius = 15
    dateLabel.layer.masksToBounds = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addConstraint()
  {
    dateLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(10)
      make.left.equalTo(self.snp.leftMargin).inset(10)
      make.height.equalTo(30)
      make.width.equalTo(100)
    }
    
    carouselView.snp.makeConstraints { (make) in
      make.top.equalTo(dateLabel.snp.bottom).offset(10)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
}

extension CheeseViewCell{
  func setCarouselViewDataSourceDelegate<T: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: T, forRow row: Int){
    carouselView.delegate = dataSourceDelegate
    carouselView.dataSource = dataSourceDelegate
    carouselView.tag = row
    carouselView.collectionViewLayout.invalidateLayout()
    carouselView.setContentOffset(carouselView.contentOffset, animated:false)
    
    let data = MainCheeseData.shared.mainData[row]
    loadSurveyType(data: data)
    
    DispatchQueue.main.async {[weak self] in
      self?.carouselView.reloadData()
    }
  }
  var collectionViewOffset: CGFloat {
    set { carouselView.contentOffset.x = newValue }
    get { return carouselView.contentOffset.x }
  }
}


