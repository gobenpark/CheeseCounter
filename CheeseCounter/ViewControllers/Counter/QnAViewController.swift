//
//  File.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 26..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import RxCocoa
import SwiftyImage
import DZNEmptyDataSet
import RxKeyboard



final class QnAViewController: ButtonBarPagerTabStripViewController{
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    
    settings.style.buttonBarItemTitleColor = .black
    settings.style.selectedBarBackgroundColor = .white
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.buttonBarItemFont = UIFont.CheeseFontMedium(size: 13.8)
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.selectedBarHeight = 1.5
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.buttonBarView.selectedBar.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.8588235294, blue: 0.1019607843, alpha: 1)
    self.buttonBarView.backgroundColor = .white
    changeCurrentIndexProgressive = {
      (oldCell: ButtonBarViewCell?
      , newCell: ButtonBarViewCell?
      , progressPercentage: CGFloat
      , changeCurrentIndex: Bool
      , animated: Bool) -> Void in
      
      guard changeCurrentIndex == true else { return }
      oldCell?.label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
      newCell?.label.textColor = .black
    }
  }
  
  override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    return [QnAQViewController(),MyInquireViewController()]
  }
}


final class QnAQViewController: UIViewController, IndicatorInfoProvider{
  
  let disposeBag = DisposeBag()
  
  fileprivate let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "제목"
    label.font = UIFont.CheeseFontMedium(size: 13.7)
    label.sizeToFit()
    return label
  }()
  
  lazy var titleTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "제목 입력(필수)"
    textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    textField.leftViewMode = .always
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    button.setImage(#imageLiteral(resourceName: "share_close@1x").withRenderingMode(.alwaysTemplate), for: .normal)
    textField.rightView = button
    textField.rightViewMode = .whileEditing
    textField.layer.borderWidth = 0.5
    textField.layer.borderColor = UIColor.lightGray.cgColor
    return textField
  }()
  
  fileprivate let commentLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.font = UIFont.CheeseFontMedium(size: 13.7)
    label.text = "내용"
    return label
  }()
  
  lazy var commentTextView: UITextView = {
    let textView = UITextView()
    textView.layer.borderWidth = 0.5
    textView.layer.borderColor = UIColor.lightGray.cgColor
    return textView
  }()
  
  fileprivate let alertLabel: UILabel = {
    let label = UILabel()
    label.text = "입력하신 개인정보 및 결제정보는 고객님의 문의내용을 처리하기 위해\n"
      + "사용되며,다른 용도로 사용하지 않습니다.\n"
      + "수집된 개인정보(아이디)와 기기정보(모델명,OS버전)는 전자상거래법에\n"
      + "따라 3년간 보관 후 삭제됩니다."
    label.font = UIFont.CheeseFontLight(size: 11)
    label.lineBreakMode = .byWordWrapping
    label.textColor = .lightGray
    label.numberOfLines = 0
    label.sizeToFit()
    return label
  }()
  
  lazy var commitButton: UIButton = {
    let button = UIButton()
    button.isEnabled = false
    button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_2_nomal@1x"), for: .normal)
    button.setBackgroundImage(UIImage.resizable().color(#colorLiteral(red: 1, green: 0.848323524, blue: 0.005472274031, alpha: 1)).image, for: .selected)
    button.setTitle("문의하기", for: .normal)
    return button
  }()
  
  lazy var scrollView: UIScrollView = {
    let view = UIScrollView()
    view.isScrollEnabled = true
    view.backgroundColor = .white
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    view.addSubview(titleLabel)
    view.addSubview(titleTextField)
    view.addSubview(commentLabel)
    view.addSubview(commentTextView)
    view.addSubview(alertLabel)
    view.addSubview(commitButton)
    
    navigationBarSetup()
    addConstraint()
    
    view.rx.tapGesture()
      .subscribe {[weak self] (_) in
        self?.titleTextField.endEditing(true)
        self?.commentTextView.endEditing(true)
    }.disposed(by: disposeBag)
  
    let viewModel = QnAViewModel()
  
    titleTextField.rx.text
      .orEmpty
      .bind(to: viewModel.title)
      .disposed(by: disposeBag)
    
    commentTextView.rx.text
      .orEmpty
      .bind(to: viewModel.comment)
      .disposed(by: disposeBag)
    
    viewModel
      .isVaild
      .bind(to: commitButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    viewModel
      .isVaild
      .bind(to: commitButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    commitButton.rx
      .tap
      .flatMap{[unowned self] _ in
        CheeseService.provider.rx.request(.insertQna(title: self.titleTextField.text!, contents: self.commentTextView.text!))
          .filter(statusCode: 200)
      }.subscribe { (event) in
        log.info(event)
      }.disposed(by: disposeBag)
  }
  
  private func addConstraint(){
    
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalTo(12)
      make.top.equalTo(20)
    }
    
    titleTextField.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(12.5)
      make.left.equalTo(12)
      make.right.equalToSuperview().inset(10)
      make.height.equalTo(43)
    }
    
    commentLabel.snp.makeConstraints { (make) in
      make.top.equalTo(titleTextField.snp.bottom).offset(22.5)
      make.left.equalTo(titleTextField)
    }
    
    commentTextView.snp.makeConstraints { (make) in
      make.left.equalTo(commentLabel)
      make.top.equalTo(commentLabel.snp.bottom).offset(13)
      make.height.equalTo(150)
      make.right.equalToSuperview().inset(12)
    }
    
    alertLabel.snp.makeConstraints { (make) in
      make.top.equalTo(commentTextView.snp.bottom).offset(10)
      make.left.equalTo(commentTextView)
      make.right.equalTo(commentTextView)
    }
    
    commitButton.snp.makeConstraints { (make) in
      make.top.equalTo(alertLabel.snp.bottom).offset(10)
      make.left.equalTo(titleTextField)
      make.right.equalTo(titleTextField)
      make.height.equalTo(50)
    }
  }
  
  private func navigationBarSetup(){
    let titleLabel = UILabel()
    titleLabel.text = "1:1 문의"
    titleLabel.font = UIFont.CheeseFontBold(size: 17)
    titleLabel.sizeToFit()
    self.navigationItem.titleView = titleLabel
  }

  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "문의하기")
  }
}

final class MyInquireViewController: UIViewController, IndicatorInfoProvider{
  var qnaList: [QnaListData.Data]?{
    didSet{
      self.collectionView.reloadData()
    }
  }
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(MyInquireView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MyInquireView.ID)
    collectionView.register(MyInquireViewCell.self, forCellWithReuseIdentifier: MyInquireViewCell.ID)
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 54, right: 0)
    collectionView.reloadEmptyDataSet()
    
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view = collectionView
    self.view.backgroundColor = .white
    fetch()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.fetch()
  }
  
  func fetch(){
    CheeseService.getQnaList { (response) in
      switch response.result {
      case .success(let value):
        self.qnaList = value.data
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
  }
  @objc fileprivate dynamic func expandAction(_ sender: UIGestureRecognizer){
    
    guard let expand = qnaList?[sender.view?.tag ?? 0].isExpand else {return}
    if expand{
      qnaList?[sender.view?.tag ?? 0].isExpand = false
    }else {
      qnaList?[sender.view?.tag ?? 0].isExpand = true
    }
    self.collectionView.reloadSections(IndexSet(integer: sender.view?.tag ?? 0))
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "나의 문의")
  }
}

extension MyInquireViewController: UICollectionViewDataSource{
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    guard let count = qnaList?.count else {return 0}
    if count == 0 {
      self.collectionView.backgroundView = EmptyView()
    }else {
      self.collectionView.backgroundView = nil
    }
    return count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    guard let expand = qnaList?[section].isExpand else {return 0}
    if expand {
      return 1
    }else {
      return 0
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyInquireViewCell.ID, for: indexPath) as! MyInquireViewCell
    cell.fetchData(data: qnaList?[indexPath.section])
    return cell
  }

  func collectionView(_ collectionView: UICollectionView
    , viewForSupplementaryElementOfKind kind: String
    , at indexPath: IndexPath) -> UICollectionReusableView {

    let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyInquireView.ID, for: indexPath) as! MyInquireView
    view.fetchData(data: qnaList?[indexPath.section])
    view.tag = indexPath.section
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandAction(_:))))
    return view
  }
}

extension MyInquireViewController: UICollectionViewDelegateFlowLayout{

  func collectionView(_ collectionView: UICollectionView
    , layout collectionViewLayout: UICollectionViewLayout
    , sizeForItemAt indexPath: IndexPath) -> CGSize {

    if let content = qnaList?[indexPath.section].q_contents{
      let height = content.boundingRect(with: CGSize(width: 372-52, height: 1000)
        , attributes:[NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)]).height
      if let answer = qnaList?[indexPath.section].a_contents{
        let answerheight = answer.boundingRect(with: CGSize(width: 372-52, height: 1000)
          , attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)]).height

        return CGSize(width: collectionView.frame.width, height: height+answerheight+150)
      } else {
        return CGSize(width: collectionView.frame.width, height: height + 100)
      }
    }

    return CGSize(width: collectionView.frame.width, height: 100)
  }

  func collectionView(_ collectionView: UICollectionView
    , layout collectionViewLayout: UICollectionViewLayout
    , referenceSizeForHeaderInSection section: Int) -> CGSize {

    return CGSize(width: collectionView.frame.width, height: 50)
  }
}

class MyInquireViewCell: UICollectionViewCell{

  static let ID = "MyInquireViewCell"

  let searchIcon: UIImageView = {
    let imgView = UIImageView(image: #imageLiteral(resourceName: "icon_q@1x"))
    return imgView
  }()

  let answerIcon: UIImageView = {
    let imgView = UIImageView(image: #imageLiteral(resourceName: "icon_a@1x"))
    return imgView
  }()

  let commentLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.font = UIFont.systemFont(ofSize: 14)
    label.numberOfLines = 0
    return label
  }()

  let answerLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()

  let answerDate: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.font = UIFont.systemFont(ofSize: 10)
    label.textColor = .lightGray
    label.textAlignment = NSTextAlignment.left
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(commentLabel)
    contentView.addSubview(searchIcon)
    contentView.addSubview(answerIcon)
    contentView.addSubview(answerLabel)
    contentView.addSubview(answerDate)

    searchIcon.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(26)
      make.top.equalToSuperview().inset(16)
      make.height.equalTo(21)
      make.width.equalTo(21)
    }

    commentLabel.snp.makeConstraints { (make) in
      make.left.equalTo(searchIcon.snp.right)
      make.top.equalTo(searchIcon)
      make.right.equalTo(self.snp.rightMargin).inset(26)
    }

    answerIcon.snp.makeConstraints { (make) in
      make.left.equalTo(searchIcon)
      make.height.equalTo(searchIcon.snp.height)
      make.width.equalTo(searchIcon.snp.width)
      make.top.equalTo(commentLabel.snp.bottom).offset(32)
    }

    answerLabel.snp.makeConstraints { (make) in
      make.left.equalTo(answerIcon.snp.right)
      make.top.equalTo(answerIcon)
      make.right.equalToSuperview().inset(26)
    }

    answerDate.snp.makeConstraints { (make) in
      make.left.equalTo(answerLabel)
      make.top.equalTo(answerLabel.snp.bottom).offset(26)
    }
  }

  func fetchData(data:QnaListData.Data?){
    self.commentLabel.text = data?.q_contents ?? ""
    self.answerLabel.text = data?.a_contents ?? ""
    self.answerDate.text = (data?.a_created_date ?? "")
      .components(separatedBy: " ")[0]
      .replacingOccurrences(of: "-", with: ".")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class MyInquireView: UICollectionReusableView{

  static let ID = "MyInquireView"

  let dividLine: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()

  let titleLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.font = UIFont.systemFont(ofSize: 16)
    return label
  }()

  let dateLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.font = UIFont.systemFont(ofSize: 11)
    return label
  }()

  let completeLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.font = UIFont.systemFont(ofSize: 16)
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleLabel)
    addSubview(dateLabel)
    addSubview(completeLabel)
    addSubview(dividLine)

    backgroundColor = .white

    dividLine.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(0.5)
    }

    titleLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(26)
      make.centerY.equalToSuperview()
    }

    dateLabel.snp.makeConstraints { (make) in
      make.left.equalTo(titleLabel.snp.right).offset(10)
      make.centerY.equalTo(titleLabel)
    }

    completeLabel.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(21)
      make.centerY.equalToSuperview()
    }
  }

  func fetchData(data:QnaListData.Data?){
    self.titleLabel.text = data?.q_title ?? ""
    self.dateLabel.text = (data?.a_created_date ?? "")
      .components(separatedBy: " ")[0]
      .replacingOccurrences(of: "-", with: ".")
    if let status = data?.q_status{
      if status == "ready"{
        self.completeLabel.text = "대기"
        self.completeLabel.textColor = .black
      }else {
        self.completeLabel.text = "완료"
        self.completeLabel.textColor = #colorLiteral(red: 1, green: 0.5535024405, blue: 0.3549469709, alpha: 1)
      }
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}



