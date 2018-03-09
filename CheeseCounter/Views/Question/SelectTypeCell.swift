//
//  SelectImageViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 24..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class SelectTypeCell: UITableViewCell {
  
  static let ID = "SelectTypeCell"
  
  var questionViewController: QuestionTableViewController?{
    didSet{
      if questionViewController?.questionData.type == "2"{
        self.secondWayButton.isSelected = true
        self.fourWayButton.isSelected = false
      } else {
        self.fourWayButton.isSelected = true
        self.secondWayButton.isSelected = false
      }
    }
  }
  
  lazy var secondWayButton: UIButton = {
    let button = UIButton()
    button.setTitle("2지 선다", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1), for: .normal)
    button.setTitleColor(#colorLiteral(red: 1, green: 0.4823529412, blue: 0.2745098039, alpha: 1), for: .selected)
    button.titleLabel?.font = UIFont.CheeseFontBold(size: 14.8)
    button.tag = 0
    button.addTarget(self, action: #selector(selectAction(_:)), for: .touchUpInside)
    return button
  }()
  
  lazy var fourWayButton: UIButton = {
    let button = UIButton()
    button.setTitle("4지 선다", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1), for: .normal)
    button.setTitleColor(#colorLiteral(red: 1, green: 0.4823529412, blue: 0.2745098039, alpha: 1), for: .selected)
    button.titleLabel?.font = UIFont.CheeseFontBold(size: 14.8)
    button.addTarget(self, action: #selector(selectAction(_:)), for: .touchUpInside)
    button.tag = 1
    return button
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    self.addSubview(secondWayButton)
    self.addSubview(fourWayButton)
    self.backgroundColor = .white
    
    secondWayButton.snp.makeConstraints { (make) in
      make.right.equalTo(self.snp.centerX).inset(9)
      make.centerY.equalToSuperview()
      make.left.equalToSuperview().inset(9)
      make.height.equalToSuperview().dividedBy(1.3)
    }
    
    fourWayButton.snp.makeConstraints { (make) in
      make.left.equalTo(self.snp.centerX).inset(-9)
      make.right.equalToSuperview().inset(9)
      make.centerY.equalToSuperview()
      make.height.equalToSuperview().dividedBy(1.3)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func selectAction(_ sender: UIButton){
    
    switch sender.tag {
    case 0:
      if !sender.isSelected{
        self.questionViewController?.questionData.type = "2"
        self.questionViewController?.tableView.reloadRows(at: [IndexPath(item: 3, section: 0)], with: .fade)
        self.fourWayButton.isSelected = false
        self.secondWayButton.isSelected = true
      }
      
    case 1:
      if !sender.isSelected{
        self.questionViewController?.questionData.type = "4"
        self.questionViewController?.tableView.reloadRows(at: [IndexPath(item: 3, section: 0)], with: .fade)
        self.secondWayButton.isSelected = false
        self.fourWayButton.isSelected = true
      }
      
    default:
      break
    }
    
  }
}
