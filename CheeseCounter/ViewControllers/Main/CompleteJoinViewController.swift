//
//  CompleteJoinViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 30..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class CompleteJoinViewController: BaseSetupViewController {
  
  let mainLabel: UILabel = {
    let label = UILabel()
    label.text = "THANK YOU!"
    label.font = UIFont.CheeseFontMedium(size: 20)
    return label
  }()
  
  let mainImgView: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "bg_illust_join@1x"))
    return img
  }()
  
  let subTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "치즈 카운터의\n회원이 되셨습니다!"
    label.numberOfLines = 0
    label.font = UIFont.CheeseFontBold(size: 25)
    label.adjustsFontSizeToFitWidth = true
    label.sizeToFit()
    label.textAlignment = .center
    return label
  }()
  
  let subDetailLabel: UILabel = {
    let label = UILabel()
    label.text = "입력해주신 정보를 통해 회원님께\n맞춤형 질문을 드립니다."
    label.sizeToFit()
    label.textColor = .lightGray
    label.numberOfLines = 0
    label.textAlignment = .center
    label.font = UIFont.CheeseFontLight(size: 15)
    return label
  }()
  
  lazy var startButton: UIButton = {
    let button = UIButton()
    button.setTitle("시작하기", for: .normal)
    button.backgroundColor = #colorLiteral(red: 1, green: 0.4, blue: 0.1882352941, alpha: 1)
    button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if self.userSetupViewController?.signUp.addr1 == nil ||
      self.userSetupViewController?.signUp.addr2 == nil{
      AlertView(title: "알림", message: "지역을 입력해 주세요", preferredStyle: .alert)
        .addChildAction(title: "확인", style: .default, handeler: { (_) in
          self.userSetupViewController?.setUpPageViewController.scrollToViewController(index: 4)
        })
        .show()
    }

  }
  
  func setUp(){
    
    self.view.backgroundColor = .white
    self.view.addSubview(mainLabel)
    self.view.addSubview(mainImgView)
    self.view.addSubview(subTitleLabel)
    self.view.addSubview(subDetailLabel)
    self.view.addSubview(startButton)
    
    mainLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(50)
      make.centerX.equalToSuperview()
    }
    
    mainImgView.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.centerX.equalToSuperview()
      make.height.lessThanOrEqualTo(300)
      make.width.equalTo(mainImgView.snp.height)
    }
    
    subTitleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(mainImgView.snp.bottom).offset(10).priority(999)
      make.centerX.equalToSuperview()
      make.width.equalToSuperview()
      make.height.lessThanOrEqualTo(80)
    }
    
    subDetailLabel.snp.makeConstraints { (make) in
      make.top.equalTo(subTitleLabel.snp.bottom).offset(10).priority(999)
      make.centerX.equalToSuperview()
      make.height.lessThanOrEqualTo(80)
    }
    
    startButton.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview().inset(50)
      make.left.equalToSuperview().inset(25)
      make.right.equalToSuperview().inset(25)
      make.height.equalTo(50)
      make.top.equalTo(subDetailLabel.snp.bottom).offset(10)
    }
  }
  
  @objc fileprivate dynamic func loginAction(){
    self.userSetupViewController?.uploadUserInfo()
  }
}
