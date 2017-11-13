//
//  CheeseRankView.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 6. 7..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import DZNEmptyDataSet

class CheeseRankView: UICollectionViewCell, UICollectionViewDelegate{
  
  static let ID = "CheeseRankView"
  
  var rankDatas:[RankData.Data]?{
    didSet{
      collectionView.reloadData()
    }
  }

  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 2
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.emptyDataSetSource = self
    collectionView.emptyDataSetDelegate = self
    collectionView.alwaysBounceVertical = true
    collectionView.register(CheeseRankReuseView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: CheeseRankReuseView.self))
    collectionView.register(CheeseRankViewCell.self, forCellWithReuseIdentifier: String(describing: CheeseRankViewCell.self))
    collectionView.backgroundColor = .white
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(collectionView)
    collectionView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
   func fetchData(){
    PointService.getTopRankList { (response) in
      switch response.result{
      case .success(let value):
        self.rankDatas = value.datas
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CheeseRankView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.rankDatas?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: CheeseRankReuseView.self), for: indexPath)
    return view
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CheeseRankViewCell.self), for: indexPath) as! CheeseRankViewCell
    cell.fetchData(data: rankDatas?[indexPath.item])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 30)
  }
}

extension CheeseRankView: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 70)
  }
}

extension CheeseRankView: DZNEmptyDataSetDelegate{
}

extension CheeseRankView: DZNEmptyDataSetSource{
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    return NSAttributedString(string: "아직 순위가 없어요"
      , attributes: [NSAttributedStringKey.foregroundColor:UIColor.lightGray,NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 18)])
  }
}

fileprivate class CheeseRankViewCell: UICollectionViewCell{
  
  let rankLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 17)
    return label
  }()
  
  let profileImg: UIImageView = {
    let imgView = UIImageView()
    imgView.layer.masksToBounds = true
    imgView.layer.cornerRadius = 70/4
    return imgView
  }()
  
  let idLabel: UILabel = {
    let label = UILabel()
    
    label.numberOfLines = 2
    return label
  }()
  
  let cheeseLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 14)
    label.textAlignment = .right
    label.textColor = .lightGray
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(rankLabel)
    contentView.addSubview(profileImg)
    contentView.addSubview(idLabel)
    contentView.addSubview(cheeseLabel)
    
    rankLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(20)
      make.centerY.equalToSuperview().inset(-1)
      make.width.equalTo(30)
    }
    
    profileImg.snp.makeConstraints { (make) in
      make.left.equalTo(rankLabel.snp.right).offset(5)
      make.centerY.equalToSuperview()
      make.height.equalToSuperview().dividedBy(2)
      make.width.equalTo(profileImg.snp.height)
    }
    
    idLabel.snp.makeConstraints { (make) in
      make.left.equalTo(profileImg.snp.right).offset(10)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview().inset(1)
      make.width.equalToSuperview().dividedBy(2.5)
    }
    
    cheeseLabel.snp.makeConstraints { (make) in
      make.left.equalTo(idLabel.snp.right)
      make.bottom.equalTo(idLabel)
      make.top.equalTo(idLabel)
      make.right.equalToSuperview().inset(25)
    }
  }

  func fetchData(data:RankData.Data?){
    self.rankLabel.text = data?.rank ?? "0"
    profileImg.kf.setImage(with: URL(string: data?.img_url ?? ""))
    

    let attribute = NSMutableAttributedString(string: data?.nickname ?? "",
                                              attributes: [NSAttributedStringKey.font: UIFont.CheeseFontMedium(size: 14)])
    attribute.append(NSAttributedString(string: "\n\(data?.title ?? "")",
      attributes: [NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 11),NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.9960784314, green: 0.4705882353, blue: 0.2862745098, alpha: 1)]))
    
    idLabel.attributedText = attribute
    
    guard let count = Int(data?.cheese ?? "0") else {return}
    cheeseLabel.text = count.stringFormattedWithSeparator() + " 치즈"
    setNeedsLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class CheeseRankReuseView: UICollectionReusableView{
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Top 100"
    label.font = UIFont.CheeseFontRegular(size: 14)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(titleLabel)
    self.backgroundColor = #colorLiteral(red: 0.9567790627, green: 0.9569162726, blue: 0.956749022, alpha: 1)
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(10)
      make.centerY.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
