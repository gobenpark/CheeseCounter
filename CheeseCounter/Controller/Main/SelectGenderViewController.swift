
//
//  SelectGenderViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 30..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

final class SelectGenderViewController: BaseSetupViewController {
  
  //MARK: - property
  
  fileprivate let mainLabel: UILabel = {
    let label = UILabel()
    label.text = "회원님의 성별을 선택해주세요."
    label.font = UIFont.boldSystemFont(ofSize: 15)
    label.textAlignment = .center
    label.sizeToFit()
    return label
  }()
  
  fileprivate lazy var maleImageButton: UIButton = {
    let mib = UIButton()
    mib.setImage(#imageLiteral(resourceName: "male_nomal@1x"), for: .normal)
    mib.setImage(#imageLiteral(resourceName: "male_select@1x"), for: .selected)
    mib.addTarget(self, action: #selector(maleButtonClickAction(_:)), for: .touchUpInside)
    mib.tag = 0
    return mib
  }()
  
  fileprivate lazy var femaleImageButton: UIButton = {
    let fib = UIButton()
    fib.setImage(#imageLiteral(resourceName: "female_nomal@1x"), for: .normal)
    fib.setImage(#imageLiteral(resourceName: "female_select@1x"), for: .selected)
    fib.addTarget(self, action: #selector(femaleButtonClickAction(_:)), for: .touchUpInside)
    fib.tag = 0
    return fib
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  
  fileprivate func setUp(){
    titleLabel.text = "회원정보 추가"
    
    self.view.backgroundColor = .cheeseColor()
    self.view.addSubview(titleLabel)
    self.view.addSubview(maleImageButton)
    self.view.addSubview(femaleImageButton)
    self.view.addSubview(mainLabel)
    
    
    let height = UIScreen.main.bounds.height
    
    mainLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self.titleLabel.snp.bottom)
      make.bottom.equalTo(maleImageButton.snp.top)
      make.centerX.equalToSuperview()
    }
    
    maleImageButton.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().inset(-height/7)
      make.height.equalTo(width/3)
      make.width.equalTo(width/3)
    }
    
    femaleImageButton.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview().inset(height/7)
      make.centerX.equalToSuperview()
      make.height.equalTo(width/3)
      make.width.equalTo(width/3)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if self.userSetupViewController?.signUp.nickName == nil{
      AlertView(title: "알림", message: "닉네임을 입력해 주세요", preferredStyle: .alert)
        .addChildAction(title: "확인", style: .default, handeler: { (_) in
          self.userSetupViewController?.setUpPageViewController.scrollToViewController(index: 1)
        })
        .show()
    }

  }
  
  fileprivate dynamic func maleButtonClickAction(_ sender: UIButton)
  {
    sender.isSelected = sender.isSelected ? false : true
    if sender.isSelected{
      isdisableScroll = false
      femaleImageButton.isSelected = false
      self.userSetupViewController?.signUp.gender = SignUp.genderType.male
      self.userSetupViewController?.setUpPageViewController.scrollToViewController(index: 3)
    }
    
    if !sender.isSelected && !femaleImageButton.isSelected {
      isdisableScroll = true
    }
    
  }
  
  fileprivate dynamic func femaleButtonClickAction(_ sender: UIButton)
  {
    sender.isSelected = sender.isSelected ? false : true
    if sender.isSelected{
      maleImageButton.isSelected = false
      isdisableScroll = false
      self.userSetupViewController?.signUp.gender = SignUp.genderType.female
      self.userSetupViewController?.setUpPageViewController.scrollToViewController(index: 3)
    }
    
    if !sender.isSelected && !maleImageButton.isSelected {
      isdisableScroll = true
    }
    
  }
  
  override func swipeAction() {
    if self.femaleImageButton.tag == 0 || self.maleImageButton.tag == 0{
      let alertController = UIAlertController(title: "알림", message: "성별을 선택하세요", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
      alertController.addAction(alertAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }
}
