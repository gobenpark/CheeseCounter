//
//  QuestionCheeseSetCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 22..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit


class QuestionCheeseSetCell: UITableViewCell {
  
  static let ID = "QuestionCheeseSetCell"
  
  //MARK: - UI
  
  weak var questionViewController: QuestionTableViewController?{
    didSet{
    }
  }
  
  var knowHowTap:(() -> Void)?
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "제공골드/1인"
    label.font = UIFont.CheeseFontMedium(size: 14)
    label.textColor = .lightGray
    label.sizeToFit()
    return label
  }()
  
  let titleLabel1: UILabel = {
    let label = UILabel()
    label.text = "응답자 수"
    label.font = UIFont.CheeseFontMedium(size: 14)
    label.textColor = .lightGray
    label.sizeToFit()
    return label
  }()
  
  let shopCalculateView: CalculateView = {
    let view = CalculateView()
    view.goldLabel.text = "필요 골드"
    return view
  }()
  
  let currentCalculateView: CalculateView = {
    let view = CalculateView()
    view.goldLabel.text = "보유 골드"
    return view
  }()
  
  lazy var buttons: [CheeseButton] = {
    var button = [CheeseButton]()
    for i in 0...9 {
      let butt = CheeseButton()
      butt.tag = i
      butt.titleLabel?.font = UIFont.CheeseFontRegular(size: 14)
      butt.setTitleColor(.black, for: .normal)
      butt.setBackgroundImage(#imageLiteral(resourceName: "txt_box_5_nomal@1x"), for: .normal)
      if i < 3{
        butt.setTitleColor(.white, for: .highlighted)
        butt.setBackgroundImage(#imageLiteral(resourceName: "txt_box_5_select@1x"), for: .highlighted)
      }else {
        butt.setTitleColor(.white, for: .selected)
        butt.setBackgroundImage(#imageLiteral(resourceName: "txt_box_5_select@1x"), for: .selected)
      }
      
      
      butt.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
      button.append(butt)
    }
    return button
  }()
  
  lazy var knowHowButton: UIButton = {
    let button = UIButton()
    button.setTitle("골드", for: .normal)
    button.setTitleColor(UIColor.lightGray, for: .normal)
    button.titleLabel?.font = UIFont.CheeseFontMedium(size: 14)
    button.setImage(#imageLiteral(resourceName: "icon_gold@1x"), for: .normal)
    button.addTarget(self, action: #selector(knowHowButtonTap), for: .touchUpInside)
    return button
  }()
  
  lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "share_close@1x"), for: .normal)
    button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    return button
  }()
  
  let setGoldLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 15)
    label.text = "설정골드: 0"
    return label
  }()
  
  //MARK: - Init
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    self.isUserInteractionEnabled = true
    setUp()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func defaultButtonSet(){
    
    guard let peopleNumSet = questionViewController?.questionData.option_set_count else {return}
    guard let setGold = Int(questionViewController?.questionData.option_cut_cheese ?? "0") else {return}
    
    self.setGoldLabel.text = "설정골드: " + setGold.stringFormattedWithSeparator()
    
    buttons[0...2].forEach({ (button) in
      button.isSelected = false
    })
    
    switch peopleNumSet {
    case "100":
      buttonAction(buttons[3])
    case "300":
      buttonAction(buttons[4])
    case "500":
      buttonAction(buttons[5])
    case "700":
      buttonAction(buttons[6])
    case "1000":
      buttonAction(buttons[7])
      
    default:
      buttons[3...7].forEach({ (button) in
        button.isSelected = false
      })
    }
  }
  
  
  //MARK: - Action
  
  func knowHowButtonTap(){
    guard let tap = knowHowTap else {return}
    tap()
  }
  
  fileprivate dynamic func cancelAction(){
    self.questionViewController?.questionData.option_cut_cheese = "0"
    self.setGoldLabel.text = "설정골드: 0"
    calculateGold()
    setNeedsLayout()
    layoutIfNeeded()
  }
  
  func calculateGold(){
    
    guard let peopleNumber = Int(questionViewController?.questionData.option_set_count ?? "0") else {return}
    guard let cheeseNumber = Int(questionViewController?.questionData.option_cut_cheese ?? "0") else {return}
//    if peopleNumber != 0 && cheeseNumber != 0{
      let totalNumber = peopleNumber*cheeseNumber
      let totalString = totalNumber.stringFormattedWithSeparator()
      confirmGold(gold: totalNumber)
      self.shopCalculateView.detailGoldLabel.text = totalString+"골드"
//    }
    
  }
  
  func confirmGold(gold:Int){
    if let currentGold = Int(self.questionViewController?.pointData?.gold ?? "0"){
      if gold > currentGold {
        AlertView(title: "골드가 부족합니다", message: "카운터로 이동하시겠습니까?", preferredStyle: .alert)
          .addChildAction(title: "예", style: .default, handeler: { (_) in
            self.questionViewController?.moveTabBarGold()
            NotificationCenter.default.post(name: NSNotification.Name("goldView"), object: nil)
          })
          .addChildAction(title: "아니오", style: .destructive, handeler: nil)
          .show()
      }
    }
  }
  
  
  func setUp(){
    
    self.selectionStyle = .none
    
    let width = UIScreen.main.bounds.width
    
    var devideLine: [UIView] = {
      var line: [UIView] = []
      for _ in 0...1{
        let view = UIView()
        view.backgroundColor = .gray
        line.append(view)
      }
      return line
    }()
    
    devideLine.append(UIView())
    devideLine.append(UIView())
    
    contentView.addSubview(titleLabel)
    
    contentView.addSubview(titleLabel1)
    contentView.addSubview(shopCalculateView)
    contentView.addSubview(cancelButton)
    contentView.addSubview(currentCalculateView)
    contentView.addSubview(knowHowButton)
    contentView.addSubview(setGoldLabel)
    
    
    buttonSetting()
    
    for i in buttons{
      contentView.addSubview(i)
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.topMargin)
      make.left.equalToSuperview().inset(25)
    }
    
    knowHowButton.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(25)
      make.top.equalTo(self.snp.topMargin)
    }
    
    buttons[0].snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.top.equalTo(self.titleLabel.snp.bottom).offset(15)
      make.height.equalTo(40)
      make.width.equalTo(width/3.5)
    }
    
    buttons[1].snp.makeConstraints { (make) in
      make.top.equalTo(buttons[0])
      make.centerX.equalToSuperview()
      make.height.equalTo(40)
      make.width.equalTo(width/3.5)
    }
    
    buttons[2].snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(25)
      make.top.equalTo(self.buttons[0])
      make.height.equalTo(40)
      make.width.equalTo(width/3.5)
    }
    
    titleLabel1.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.top.equalTo(buttons[0].snp.bottom).offset(20)
    }

    buttons[3].snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.top.equalTo(titleLabel1.snp.bottom).offset(20)
      make.width.equalTo((width-50)/6)
      make.height.equalTo(40)
    }
    
    buttons[4].snp.makeConstraints { (make) in
      make.left.equalTo(buttons[3].snp.right).offset((width-50)/48)
      make.bottom.equalTo(buttons[3])
      make.width.equalTo(buttons[3])
      make.height.equalTo(buttons[3])
    }
    
    buttons[5].snp.makeConstraints { (make) in
      make.left.equalTo(buttons[4].snp.right).offset((width-50)/48)
      make.bottom.equalTo(buttons[3])
      make.width.equalTo(buttons[3])
      make.height.equalTo(buttons[3])
    }
    
    buttons[6].snp.makeConstraints { (make) in
      make.left.equalTo(buttons[5].snp.right).offset((width-50)/48)
      make.bottom.equalTo(buttons[3])
      make.width.equalTo(buttons[3])
      make.height.equalTo(buttons[3])
    }
    
    buttons[7].snp.makeConstraints { (make) in
      make.left.equalTo(buttons[6].snp.right).offset((width-50)/48)
      make.right.equalToSuperview().inset(25)
      make.bottom.equalTo(buttons[3])
      make.width.equalTo(buttons[3])
      make.height.equalTo(buttons[3])
    }
    
    setGoldLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.top.equalTo(buttons[3].snp.bottom).offset(20)
    }
    
    shopCalculateView.snp.makeConstraints { (make) in
      make.top.equalTo(setGoldLabel.snp.bottom).offset(10)
      make.left.equalToSuperview().inset(25)
      make.right.equalToSuperview().inset(25)
      make.height.equalTo(50)
    }
    
    currentCalculateView.snp.makeConstraints { (make) in
      make.top.equalTo(shopCalculateView.snp.bottom)
      make.left.equalToSuperview().inset(25)
      make.right.equalToSuperview().inset(25)
      make.height.equalTo(50)
    }
    
    cancelButton.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(25)
      make.centerY.equalTo(setGoldLabel)
      make.height.equalTo(20)
      make.width.equalTo(20)
    }
  }
  
  func buttonSetting(){
    
    buttons[0].setTitle("100 골드", for: .normal)
    buttons[0].count = 100
    buttons[1].setTitle("500 골드", for: .normal)
    buttons[1].count = 500
    buttons[2].setTitle("1,000 골드", for: .normal)
    buttons[2].count = 1000
    buttons[3].setTitle("100명", for: .normal)
    buttons[3].count = 100
    buttons[4].setTitle("300명", for: .normal)
    buttons[4].count = 300
    buttons[5].setTitle("500명", for: .normal)
    buttons[5].count = 500
    buttons[6].setTitle("700명", for: .normal)
    buttons[6].count = 700
    buttons[7].setTitle("1,000명", for: .normal)
    buttons[7].count = 1000
  }
  
  func buttonAction(_ sender: UIButton){
    
    switch sender.tag {
    case 0...2:
      if let gold = Int(self.questionViewController?.questionData.option_cut_cheese ?? "0"){
        self.questionViewController?.questionData.option_cut_cheese = "\(buttons[sender.tag].count + gold)"
        self.setGoldLabel.text = "설정골드: \((buttons[sender.tag].count + gold).stringFormattedWithSeparator())"
        self.setGoldLabel.sizeToFit()
      }
    case 3...7:
    self.questionViewController?.questionData.option_set_count = "\(buttons[sender.tag].count)"
    for i in 3...7{
      buttons[i].isSelected = false
      }
      sender.isSelected = true
    default:
      break
    }
    calculateGold()
    setNeedsLayout()
  }
}

class CheeseButton: UIButton{
  var count = 0
}

