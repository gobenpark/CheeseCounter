//
//  SympathyTableViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 7..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class SympathyTableViewController: BaseListViewController{
  
  override func setUp(){
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.defaultText = "서로의 소통을 위한 당신의 공감이 필요합니다."
    self.collectionView.register(SympathyCell.self
      , forCellWithReuseIdentifier: String(describing: SympathyCell.self))
  }
  
  override func fetch(paging: Paging){
    
    guard !self.isLoading else { return }
    self.isLoading = true
    CheeseService.getEmpathyList(paging: paging) {[weak self] (response) in
      guard let `self` = self else {return}
      self.isLoading = false
      switch response.result {
      case .success(let data):
        let newData = data.data ?? []
        switch paging {
        case .refresh:
          self.cheeseData = newData
          self.nextPageNumber = 0
        case .next:
          guard !newData.isEmpty else {return}
          self.cheeseData.append(contentsOf: newData)
          self.nextPageNumber += 1
        }
        self.collectionView.reloadData()
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cheeseData.count
  }
  
  override func collectionView(_ collectionView: UICollectionView
    , cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: String(describing: SympathyCell.self)
      , for: indexPath) as! SympathyCell
    
    cell.dataUpdate(data: cheeseData[indexPath.item])
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    var cheeseResult = CheeseResult(cheeseData: cheeseData[indexPath.item], resultData: resultData)
    cheeseResult.cheeseData.is_empathy = "1"
    self.delegate?.pushViewController(cheeseData: cheeseResult)
  }
}

class SympathyCell: UICollectionViewCell{
  
  let sympathyImg: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "result_like_small@1x"))
    return img
  }()
  
  let sympathyLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 13)
    label.textColor = .lightGray
    label.sizeToFit()
    return label
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.font = UIFont.CheeseFontMedium(size: 16)
    return label
  }()
  
  let replyLabel: UILabel = {
    let label = UILabel()
    label.text = "최신 댓글:"
    label.font = UIFont.CheeseFontMedium(size: 16)
    label.textColor = .lightGray
    return label
  }()
  
  let detailReplyLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.font = UIFont.CheeseFontMedium(size: 13)
    label.textAlignment = .left
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(sympathyImg)
    contentView.addSubview(sympathyLabel)
    contentView.addSubview(titleLabel)
    contentView.addSubview(replyLabel)
    contentView.addSubview(detailReplyLabel)
    self.backgroundColor = .white
    addConstraint()
  }
  
  func addConstraint(){
    
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(24)
      make.top.equalToSuperview().offset(21)
      make.right.equalToSuperview().inset(24)
    }
    
    replyLabel.snp.makeConstraints { (make) in
      make.left.equalTo(titleLabel)
      make.top.equalTo(titleLabel.snp.bottom).offset(17)
    }
    
    detailReplyLabel.snp.makeConstraints { (make) in
      make.left.equalTo(replyLabel.snp.right).offset(10)
      make.centerY.equalTo(replyLabel)
      make.width.equalTo(self).dividedBy(2)
    }
    
    sympathyImg.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(53)
      make.centerY.equalTo(detailReplyLabel)
    }
    
    sympathyLabel.snp.makeConstraints { (make) in
      make.left.equalTo(sympathyImg.snp.right).offset(4)
      make.centerY.equalTo(detailReplyLabel)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func dataUpdate(data: CheeseResultByDate.Data){
    
    self.titleLabel.text = data.title ?? ""
    self.sympathyLabel.text = data.like_count ?? ""
    
    if data.recent_reply != nil {
      self.detailReplyLabel.text = data.recent_reply!
      self.detailReplyLabel.textColor = .black
    }else {
      self.detailReplyLabel.text = "최신 댓글이 없습니다."
      self.detailReplyLabel.textColor = .lightGray
    }
    
    if let count = data.like_count{
      self.sympathyImg.isHidden = false
      self.sympathyLabel.isHidden = false
      self.sympathyLabel.text = "\(count)"
    }else {
      self.sympathyImg.isHidden = true
      self.sympathyLabel.isHidden = true
    }
    replyLabel.sizeToFit()
    sympathyImg.sizeToFit()
    layoutIfNeeded()
  }
}
