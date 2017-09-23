//
//  Base.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 10..
//  Copyright © 2017년 xiilab. All rights reserved.
//

//
//  QuestionTableViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 7..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import DZNEmptyDataSet
import RxSwift
import RxCocoa

class BaseListViewController: UIViewController{
  
  var cheeseData: [CheeseResultByDate.Data] = []
  var resultData: [SurveyResult.Data] = []
  var isLoading: Bool = false{
    didSet{
      self.collectionView.reloadEmptyDataSet()
    }
  }
  var nextPageNumber: Int = 0
  var delegate: listViewControllerDelegate?
  var defaultText = ""
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 5
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(
      CollectionActivityIndicatorView.self,
      forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
      withReuseIdentifier: "activityIndicatorView"
    )
    collectionView.emptyDataSetSource = self
    collectionView.emptyDataSetDelegate = self
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()
  
  let activityView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    view.frame = UIScreen.main.bounds
    return view
  }()
  
  lazy var refresh: UIRefreshControl = {
    let refresh = UIRefreshControl()
    refresh.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
    return refresh
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    self.fetch(paging: .refresh)
//    self.collectionView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(collectionView)
    self.collectionView.backgroundColor = #colorLiteral(red: 0.9567790627, green: 0.9569162726, blue: 0.956749022, alpha: 1)
    self.collectionView.addSubview(refresh)
    
    collectionView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    setUp()
    fetch(paging: .refresh)
  }
  
  func setUp(){}
  func fetch(paging: Paging){}
  
  dynamic func refreshAction(){
    self.fetch(paging: .refresh)
    self.nextPageNumber = 1
    self.refresh.endRefreshing()
  }
}

extension BaseListViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cheeseData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseListCell.ID, for: indexPath) as! BaseListCell
    cell.dataUpdate(data: cheeseData[indexPath.item])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView
    , viewForSupplementaryElementOfKind kind: String
    , at indexPath: IndexPath) -> UICollectionReusableView {
    
    let isLastSection = indexPath.section == collectionView.numberOfSections - 1
    let isFooter = kind == UICollectionElementKindSectionFooter
    if isLastSection && isFooter {
      return collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: "activityIndicatorView",
        for: indexPath
      )
    }
    return UICollectionReusableView()
  }
}

extension BaseListViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    if (cheeseData[indexPath.item].total_count ?? "") == "0"{
      let alertController = UIAlertController(title: "응답자가 없습니다.", message: "", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
      
      AppDelegate.instance?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
      return
    }
    let cheeseResult = CheeseResult(cheeseData: cheeseData[indexPath.item], resultData: resultData)
    self.delegate?.pushViewController(cheeseData: cheeseResult)
  }
}

extension BaseListViewController : DZNEmptyDataSetSource{
  
  func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
    let label = UILabel()
    label.textAlignment = .center
    label.attributedText = NSMutableAttributedString(string: defaultText
      , attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)
        ,NSForegroundColorAttributeName:UIColor.gray])
    if isLoading{
      activityView.startAnimating()
      return activityView
    }else {
      return label
    }
  }
  
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    let text = defaultText
    let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 15),NSForegroundColorAttributeName:UIColor.gray]
    return NSAttributedString(string: text, attributes: attributes)
  }
  
  func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
    return #colorLiteral(red: 0.9489366412, green: 0.9490727782, blue: 0.9489067197, alpha: 1)
  }
}

extension BaseListViewController: DZNEmptyDataSetDelegate{
  
}

extension BaseListViewController: UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView
    , layout collectionViewLayout: UICollectionViewLayout
    , sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: UIScreen.main.bounds.width, height: 110)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let contentOffsetBottom = scrollView.contentOffset.y + scrollView.height
    let didReachBottom = scrollView.contentSize.height > 0
      && contentOffsetBottom >= scrollView.contentSize.height - 100
    if didReachBottom {
      self.fetch(paging: .next(self.nextPageNumber))
    }
  }
  
  func collectionView(_ collectionView: UICollectionView
    , layout collectionViewLayout: UICollectionViewLayout
    , referenceSizeForFooterInSection section: Int) -> CGSize {
    
    let height: CGFloat = (self.isLoading) ? 44 : 0
    return CGSize(width: collectionView.width, height: height)
  }
}

class BaseListCell: UICollectionViewCell{
  
  static let ID = "BaseListCell"
  
  let sympathyImg: UIImageView = {
    let img = UIImageView()
    return img
  }()
  
  let sympathyLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 16)
    label.sizeToFit()
    return label
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    return label
  }()
  
  let personIcon: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "icon_person@1x"))
    return img
  }()
  
  let personLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 12)
    label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    return label
  }()
  
  let calenderIcon: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "icon_calendar@1x"))
    return img
  }()
  
  let calenderLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    label.font = UIFont.CheeseFontMedium(size: 12)
    return label
  }()
  
  let cheeseIcon: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "badge_cheese_right@1x"))
    return img
  }()
  
  let chneeseLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontBold(size: 14)
    label.textColor = .white
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .white
    addSubview(sympathyImg)
    addSubview(sympathyLabel)
    addSubview(titleLabel)
    addSubview(personIcon)
    addSubview(personLabel)
    addSubview(calenderIcon)
    addSubview(calenderLabel)
    addSubview(cheeseIcon)
    cheeseIcon.addSubview(chneeseLabel)
    
    
    sympathyImg.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(24)
      make.top.equalTo(self.snp.topMargin).inset(4)
    }
    
    sympathyLabel.snp.makeConstraints { (make) in
      make.left.equalTo(sympathyImg.snp.right).offset(6)
      make.centerY.equalTo(sympathyImg).inset(-1)
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalTo(sympathyImg)
      make.centerY.equalToSuperview().inset(4)
      make.right.equalTo(cheeseIcon.snp.left)
    }
    
    personIcon.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(15)
      make.left.equalTo(titleLabel)
    }
    
    personLabel.snp.makeConstraints { (make) in
      make.left.equalTo(personIcon.snp.right).offset(10)
      make.centerY.equalTo(personIcon)
    }
    
    calenderIcon.snp.makeConstraints { (make) in
      make.left.equalTo(personLabel.snp.right).offset(10)
      make.centerY.equalTo(personIcon)
    }
    
    calenderLabel.snp.makeConstraints { (make) in
      make.left.equalTo(calenderIcon.snp.right).offset(10)
      make.centerY.equalTo(calenderIcon)
    }
    
    cheeseIcon.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(66)
      make.width.equalTo(66)
    }
    
    chneeseLabel.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview().inset(4)
      make.centerX.equalToSuperview()
    }
  }
  
  func dataUpdate(data: CheeseResultByDate.Data){
    
    self.titleLabel.text = data.title ?? ""
    if (data.is_option ?? "") == "1"{
      self.personLabel.text = (data.total_count ?? "") + "/" + (data.option_set_count ?? "")
      self.cheeseIcon.image = UIImage(named: "badge_gold_right")
      self.chneeseLabel.text = data.option_cut_cheese ?? ""
    } else {
      self.personLabel.text = data.total_count ?? ""
      self.cheeseIcon.image = UIImage(named: "badge_cheese_right")
      self.chneeseLabel.text = data.option_cut_cheese ?? ""
    }
    
    let startDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd"
    let limitDate = dateFormatter.date(from: (data.limit_date ?? "").components(separatedBy: " ")[0]) ?? Date()
    let cal = Calendar.current
    let component = cal.dateComponents([.day], from: startDate, to: limitDate).day ?? 0
    
    if component >= 0 {
      calenderLabel.text = "\(component)일 남음"
    }else {
      calenderLabel.text = "기간만료"
    }
    
    
    self.sympathyLabel.text = data.empathy_count ?? ""
    let isEmpty = data.is_empathy ?? "0"
    if isEmpty == "0"{
      self.sympathyImg.image =  #imageLiteral(resourceName: "result_like_big_nomal@1x")
      self.sympathyLabel.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    } else {
      self.sympathyImg.image = #imageLiteral(resourceName: "result_like_big_select@1x")
      self.sympathyLabel.textColor = #colorLiteral(red: 1, green: 0.5535024405, blue: 0.3549469709, alpha: 1)
    }
    
    setNeedsLayout()
    layoutIfNeeded()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
