//
//  NoticeViewController.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 4. 4..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import DZNEmptyDataSet

class NoticeViewController: UIViewController{
  
  var notices:[NoticeData.Data] = []
  
  var isEmptyViews:Bool = true
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .white
    collectionView.register(NoticeViewCell.self, forCellWithReuseIdentifier: String(describing: NoticeViewCell.self))
    collectionView.register(
      NoticeView.self
      , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
      , withReuseIdentifier: String(describing: NoticeView.self)
    )
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view = collectionView
    fetch()
  }
  
  func fetch(){
    
    CheeseService.getNoticeList { (response) in
      switch response.result{
      case .success(let value):
        guard let data = value.data else {return}
        self.notices = data
        self.collectionView.reloadData()
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
  }
  
  @objc fileprivate dynamic func expandAction(_ sender: UIGestureRecognizer){
    notices[sender.view?.tag ?? 0].isExpand =
      notices[sender.view?.tag ?? 0].isExpand ? false : true
    self.collectionView.reloadSections(IndexSet(integer: sender.view?.tag ?? 0))
  }
}

extension NoticeViewController: UICollectionViewDelegate{
}

extension NoticeViewController: UICollectionViewDataSource{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if notices[section].isExpand{
      return 1
    }else {
      return 0
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    if notices.count == 0 {
      let view = EmptyView()
      view.titleLabel.text = "새로운 공지사항이 준비 중입니다."
      self.collectionView.backgroundView = view
    }else {
      self.collectionView.backgroundView = nil
    }
    return notices.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: String(describing: NoticeViewCell.self)
      , for: indexPath) as! NoticeViewCell
    cell.fetch(data: notices[indexPath.section])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView
    , viewForSupplementaryElementOfKind kind: String
    , at indexPath: IndexPath) -> UICollectionReusableView {
    
    let view = collectionView
      .dequeueReusableSupplementaryView(
        ofKind: kind
        , withReuseIdentifier: String(describing: NoticeView.self)
        , for: indexPath) as! NoticeView
    view.fetch(data: notices[indexPath.section])
    view.tag = indexPath.section
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandAction(_:))))
    return view
  }
  
  func collectionView(_ collectionView: UICollectionView
    , layout collectionViewLayout: UICollectionViewLayout
    , referenceSizeForHeaderInSection section: Int) -> CGSize {
    
    if let title = notices[section].title {
      let size = title.boundingRect(with: CGSize(width: 374-57, height: 100)
        , attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)])
      
      return CGSize(width: collectionView.frame.width, height: size.height+30)
    }
    return CGSize(width: collectionView.frame.width, height: 50)
  }
}

extension NoticeViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView
    , layout collectionViewLayout: UICollectionViewLayout
    , sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if let content = notices[indexPath.section].contents{
      let size = content.boundingRect(with: CGSize(width: 374-42, height: 1000)
        , attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)])
      return CGSize(width: collectionView.frame.width, height: size.height+81)
    }
    
    return .zero
  }
}

class NoticeViewCell: UICollectionViewCell{
  
  let commentLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.numberOfLines = 0
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()
  
  let dateLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.font = UIFont.systemFont(ofSize: 11)
    label.textColor = .lightGray
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(commentLabel)
    contentView.addSubview(dateLabel)
    
    commentLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(21)
      make.top.equalToSuperview().inset(27)
      make.right.equalToSuperview().inset(27)
    }
    
    dateLabel.snp.makeConstraints { (make) in
      make.left.equalTo(commentLabel)
      make.top.equalTo(commentLabel.snp.bottom).offset(27)
    }
  }
  
  func fetch(data: NoticeData.Data?){
    self.commentLabel.text = data?.contents ?? ""
    self.dateLabel.text = (data?.created_date ?? "")
      .components(separatedBy: " ")[0]
      .replacingOccurrences(of: "-", with: ".")
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class NoticeView: UICollectionReusableView{
  
  let dividLine: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 2
    return label
  }()
  
  let arrowButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "arrow_open@1x"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "arrow_close@1x"), for: .selected)
    button.isUserInteractionEnabled = false
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleLabel)
    addSubview(arrowButton)
    addSubview(dividLine)
    
    dividLine.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.top.equalToSuperview()
      make.height.equalTo(0.5)
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(21)
      make.centerY.equalToSuperview()
      make.right.equalToSuperview().inset(60)
    }
    
    arrowButton.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(21)
      make.centerY.equalToSuperview()
    }
  }
  
  func fetch(data: NoticeData.Data?){
    
    let date = (data?.created_date ?? "")
      .components(separatedBy: " ")[0]
      .replacingOccurrences(of: "-", with: ".")
    let attribute = NSMutableAttributedString(string: data?.title ?? ""
      , attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)])
    attribute.append(NSAttributedString(string: " "+date
      , attributes: [
        NSAttributedStringKey.font:UIFont.systemFont(ofSize: 11)
        ,NSAttributedStringKey.foregroundColor:UIColor.lightGray
      ]))
    titleLabel.attributedText = attribute
    
    if (data?.isExpand ?? false){
      arrowButton.isSelected = true
    }else {
      arrowButton.isSelected = false
    }
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


