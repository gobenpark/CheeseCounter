//
//  PayViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 13..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import Alamofire
import AAFragmentManager
import BetterSegmentedControl


class CounterViewController: UIViewController
{
  
  //MARK: - property
  
  let extendView = ExtendedCounterNavBarView(frame: .zero)
  
  var childView: AAFragmentManager = {
    let fragmanager = AAFragmentManager()
    fragmanager.allowSameFragment = true
    return fragmanager
  }()
  
  let currentGoldViewController = CurrentGoldViewController()
  let currentCheeseViewController = CurrentCheeseViewController()
  
  let setupCounterViewController = SetupCounterViewController(style: .grouped)
  
  var rankData: RankData.Data?
  
  //MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(movePayView), name: NSNotification.Name(rawValue: "goldView"), object: nil)
    
    navigationBarSetup()
    self.view.addSubview(extendView)
    self.view.addSubview(childView)
    self.view.backgroundColor = UIColor.cheeseColor()
    self.extendView.setButton.addTarget(self, action: #selector(pushsetupCounterViewController), for: .touchUpInside)
    self.extendView.segmentedControl.addTarget(self, action: #selector(segmentControlEvent(_:)), for: .valueChanged)
    let views = [currentGoldViewController,currentCheeseViewController]
    self.childView.setupFragments(views, defaultIndex: 0)
    fetch()
    addConstraint()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    currentCheeseViewController.collectionView.reloadData()
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    NotificationCenter.default.post(name: NSNotification.Name("reloadSubView"), object: nil)
    fetch()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.navigationController?.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), height: 1)
  }
  
  func navigationBarSetup(){
    
    let titleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 140, height: 30))
    titleButton.setTitle("카운터", for: .normal)
    titleButton.setImage(#imageLiteral(resourceName: "icon_gold@1x"), for: .normal)
    titleButton.addTarget(self, action: #selector(presentCoachView), for: .touchUpInside)
    titleButton.titleLabel?.font = UIFont.CheeseFontBold(size: 17)
    titleButton.semanticContentAttribute = .forceRightToLeft
    titleButton.imageEdgeInsets = UIEdgeInsets(top: 2.5, left: 10, bottom: 0, right: 0)
    titleButton.setTitleColor(.black, for: .normal)
    self.navigationItem.titleView = titleButton
  }
  
  func presentCoachView(){
    let coachView = CoachViewController()
    coachView.imgView.image = coachView.images[5]
    self.present(coachView, animated: true, completion: nil)
  }

  func keyboardWillHide(_ sender: Notification) {
    if let userInfo = (sender as NSNotification).userInfo {
      if let _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
        //key point 0,
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
          self.view.bounds.origin.y = 0
        })
      }
    }
  }
  
  func keyboardWillShow(_ sender: Notification) {
    if let userInfo = (sender as NSNotification).userInfo {
      if ((userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height) != nil {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
          self.view.bounds.origin.y = 100
        })
      }
    }
  }
  
  func movePayView(){
    self.childView.replaceFragment(withIndex: 0)
    guard let goldView = self.childView.getFragment(0) as? CurrentGoldViewController else {return}
    DispatchQueue.main.async {
      goldView.collectionView.contentOffset = CGPoint(x: goldView.collectionView.size.width, y: 0)
      goldView.counterMenuBar.collectionView.selectItem(at: IndexPath(row: 1, section: 0), animated: true, scrollPosition: .centeredVertically)
    }
  }
  
  //MARK: - Network
  
  func fetch(){
    PointService.getMyPoint { (response) in
      switch response.result {
      case .success(let value):
        guard let cheese = Int(value.data?.cheese ?? ""),
          let gold = Int(value.data?.gold ?? "") else {return}
        self.extendView.segmentedControl.titles = ["\(gold.stringFormattedWithSeparator())골드"
          ,"\(cheese.stringFormattedWithSeparator())치즈"]
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
    UserService.getMyInfo { [weak self] (response) in
      guard let `self` = self else {return}
      switch response.result{
      case .success(let value):
        guard let data = value.data else {return}
        self.rankFetch(data: data)
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
  }
  
  func rankFetch(data:UserResult.Data){
    PointService.getMyRank { (response) in
      switch response.result{
      case .success(let value):
        self.rankData = value.data
        let attributeText = NSMutableAttributedString(string: "\(data.nickname ?? "") (\(value.data?.title ?? ""), \(value.data?.rank ?? "")위)"
          , attributes: [NSFontAttributeName:UIFont.CheeseFontMedium(size: 15)])
        
        attributeText.append(NSAttributedString(string: "\n\(self.getKoreanGenderName(gender: data.gender ?? ""))/\(data.age ?? "")세/\(data.addr2 ?? "")"
          , attributes: [NSFontAttributeName:UIFont.CheeseFontMedium(size: 14),NSForegroundColorAttributeName:UIColor.lightGray]))
        self.extendView.nickNameLabel.attributedText = attributeText
        let urlString = data.img_url ?? ""
        let url = URL(string: urlString)
        if urlString != "nil" {
          self.extendView.profileImg.kf.setImage(with: url)
        }

      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
  }
  
  func getKoreanGenderName(gender:String) -> String{
    switch gender{
    case "male":
      return "남자"
    case "female":
      return "여자"
    default:
      return gender
    }
  }
  
  //MARK: - Layout
  func addConstraint()
  {
    extendView.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(117)
    }
    
    childView.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.top.equalTo(extendView.snp.bottom)
      make.bottom.equalToSuperview()
    }
  }
  
  //MARK: - Event
  
  func segmentControlEvent(_ sender: BetterSegmentedControl)
  {
    let index = Int(sender.index)
    if index == 1{
      currentCheeseViewController.collectionView.reloadData()
    }
    childView.replaceFragment(withIndex: index)
  }
  
  //MARK: - Move ViewController
  
  func pushsetupCounterViewController(){
    self.navigationController?.pushViewController(setupCounterViewController, animated: true)
  }
}

class ExtendedCounterNavBarView: UIView {
  
  let profileImg: UIImageView = {
    let img = UIImageView()
    img.image = #imageLiteral(resourceName: "profile_small@1x")
    img.contentMode = .scaleAspectFill
    img.clipsToBounds = true
    return img
  }()
  
  let nickNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.CheeseFontMedium(size: 16)
    label.sizeToFit()
    label.numberOfLines = 2
    return label
  }()
  
  lazy var setButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "icon_setting@1x"), for: .normal)
    button.sizeToFit()
    return button
  }()
  
  lazy var segmentedControl: BetterSegmentedControl = {
    let sc = BetterSegmentedControl(frame: .zero
      , titles: ["골드","치즈"]
      , index: 0
      , backgroundColor: .white
      , titleColor: .lightGray
      , indicatorViewBackgroundColor: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
      , selectedTitleColor: .white)
    sc.cornerRadius = 20
    sc.layer.borderWidth = 0.5
    sc.layer.borderColor = UIColor.lightGray.cgColor
    sc.selectedTitleFont = UIFont.CheeseFontBold(size: 15)
    sc.titleFont = UIFont.CheeseFontMedium(size: 15)
    return sc
  }()
  
  /**
   *  Called when the view is about to be displayed.  May be called more than
   *  once.
   */
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    profileImg.image = #imageLiteral(resourceName: "profile_small@1x")
    addSubview(profileImg)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)
    let bottomView = UIView()
    bottomView.backgroundColor = #colorLiteral(red: 0.9978943467, green: 0.8484466672, blue: 0.1216805503, alpha: 1)
    addSubview(segmentedControl)
    addSubview(bottomView)
    addSubview(nickNameLabel)
    addSubview(setButton)
    
    profileImg.layer.cornerRadius = 30
    profileImg.layer.masksToBounds = true
    
    segmentedControl.layer.borderWidth = 0
    
    profileImg.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(5)
      make.left.equalTo(self.snp.leftMargin).inset(10)
      make.height.equalTo(60)
      make.width.equalTo(60)
    }
    
    nickNameLabel.snp.makeConstraints { (make) in
      make.left.equalTo(profileImg.snp.right).offset(20)
      make.top.equalTo(profileImg)
      make.bottom.equalTo(profileImg)
    }
    
    setButton.snp.makeConstraints { (make) in
      make.right.equalTo(self.snp.right).inset(15)
      make.centerY.equalTo(profileImg)
      make.height.equalTo(50)
      make.width.equalTo(50)
    }
    
    bottomView.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(2)
    }
    
    segmentedControl.snp.makeConstraints { (make) in
      make.left.equalTo(self.snp.leftMargin)
      make.right.equalTo(self.snp.rightMargin)
      make.top.equalTo(profileImg.snp.bottom).offset(10)
      make.height.equalTo(40)
    }
  }
}

