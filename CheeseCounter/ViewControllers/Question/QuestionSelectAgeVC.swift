//
//  QuestionAgeSelectViewController.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 4. 9..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class QuestionSelectAgeVC: UIViewController{
  
  var didTap:((String)->())?
  
  var ages: String? {
    didSet{
      ages?.components(separatedBy: ",").forEach({ (age) in
        switch age {
        case "10":
          ageSelectButtons[0].isSelected = true
        case "20":
          ageSelectButtons[1].isSelected = true
        case "30":
          ageSelectButtons[2].isSelected = true
        case "40":
          ageSelectButtons[3].isSelected = true
        case "50":
          ageSelectButtons[4].isSelected = true
        case "60":
          ageSelectButtons[5].isSelected = true
        default:
          break
        }
      })
    }
  }
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "연령 (중복가능)"
    label.font = UIFont.CheeseFontBold(size: 16)
    label.textColor = .black
    label.sizeToFit()
    return label
  }()
  
  lazy var ageSelectButtons: [UIButton] = {
    var buttons = [UIButton]()
    for i in 0...5 {
      let button = UIButton()
      button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_5_nomal@1x"), for: .normal)
      button.tag = i
      button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_5_select@1x"), for: .selected)
      button.addTarget(self, action: #selector(checkButtonAction(_:)), for: .touchUpInside)
      button.setAttributedTitle(NSAttributedString(string: "\((i+1)*10) 대", attributes: [NSAttributedStringKey.font:UIFont.CheeseFontRegular(size: 16),
                                                                                           NSAttributedStringKey.foregroundColor:UIColor.black]), for: .normal)
      button.setAttributedTitle(NSAttributedString(string: "\((i+1)*10) 대", attributes: [NSAttributedStringKey.font:UIFont.CheeseFontBold(size: 16),
                                                                                           NSAttributedStringKey.foregroundColor:UIColor.white]), for: .selected)
      button.titleLabel?.font = UIFont.CheeseFontBold(size: 16)
      buttons.append(button)
      if i == 5{
        button.setTitle("\((i+1)*10) 대 이상", for: .normal)
      }
    }
    return buttons
  }()
  
  lazy var commitButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_select_1@1x"), for: .normal)
    button.setTitle("확인", for: .normal)
    button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(red: 254/255, green: 220/255, blue: 25/255, alpha: 0.8)
    
    self.view.addSubview(titleLabel)
    self.view.addSubview(commitButton)
    for i in 0...5 {
      view.addSubview(ageSelectButtons[i])
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(165)
      make.centerX.equalToSuperview()
    }
    
    ageSelectButtons[0].snp.makeConstraints { (make) in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(27)
      make.left.equalToSuperview().inset(25)
      make.right.equalTo(self.view.snp.centerX).inset(-10)
      make.height.equalTo(50)
    }
    
    ageSelectButtons[1].snp.makeConstraints { (make) in
      make.centerY.equalTo(ageSelectButtons[0])
      make.left.equalTo(self.view.snp.centerX).offset(10)
      make.right.equalToSuperview().inset(25)
      make.height.equalTo(50)
    }
    
    ageSelectButtons[2].snp.makeConstraints { (make) in
      make.left.equalTo(ageSelectButtons[0])
      make.right.equalTo(ageSelectButtons[0])
      make.height.equalTo(ageSelectButtons[0])
      make.top.equalTo(ageSelectButtons[0].snp.bottom).offset(20)
    }
    
    ageSelectButtons[3].snp.makeConstraints { (make) in
      make.top.equalTo(ageSelectButtons[2])
      make.right.equalTo(ageSelectButtons[1])
      make.left.equalTo(ageSelectButtons[1])
      make.height.equalTo(ageSelectButtons[1])
    }
    
    ageSelectButtons[4].snp.makeConstraints { (make) in
      make.left.equalTo(ageSelectButtons[0])
      make.right.equalTo(ageSelectButtons[0])
      make.height.equalTo(ageSelectButtons[0])
      make.top.equalTo(ageSelectButtons[2].snp.bottom).offset(20)
    }
    
    ageSelectButtons[5].snp.makeConstraints { (make) in
      make.left.equalTo(ageSelectButtons[3])
      make.right.equalTo(ageSelectButtons[3])
      make.height.equalTo(ageSelectButtons[3])
      make.top.equalTo(ageSelectButtons[4])
    }
    
    commitButton.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview().inset(37)
      make.left.equalToSuperview().inset(20)
      make.height.equalTo(50)
      make.right.equalToSuperview().inset(20)
    }
  }
  
  @objc fileprivate dynamic func checkButtonAction(_ sender: UIButton){
    sender.isSelected = sender.isSelected ? false : true
  }
  
  @objc fileprivate dynamic func buttonAction(_ sender: UIButton){
    var ageString: String = ""
    var isButtonAnyOneSelect:Bool = false
    for button in ageSelectButtons {
      if button.isSelected{
        isButtonAnyOneSelect = true
        ageString += ("," + (button.titleLabel?.text?.components(separatedBy: " ")[0] ?? ""))
      }
    }
    if !isButtonAnyOneSelect{
      alertAction()
      return
    }
    
    ageString.remove(at: ageString.startIndex)
    
    guard let tap = didTap else {return}
    tap(ageString)
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }
  
  func alertAction(){
    let alertController = UIAlertController(title: "알림", message: "연령을 선택해주세요", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }
}


