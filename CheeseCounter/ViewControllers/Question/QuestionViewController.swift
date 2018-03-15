//
//  QuestionViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 3. 13..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import Eureka

public enum QuestionType{
  case Two
  case Four
}

class QuestionViewController: FormViewController{
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "질문"
    tableView.separatorStyle = .none
    tableView.backgroundColor = .white
    form +++ Section()
      <<< TitleRow(tag: "title").cellSetup({ (cell, row) in
        row.value = NSAttributedString(string: "제목 입력 (필수)",
                                       attributes: [.font:UIFont.CheeseFontRegular(size: 14.8)])
      })
      <<< SelectionButtonRow(tag: "selectType").cellSetup({ (cell, row) in
        row.value = .Four
      })
      
      <<< ImageRow(tag: "imageRow")
      <<< AskRow("askRow")
      <<< ImageRow(tag: "imageRow1").cellUpdate({ (cell, row) in
          row.hidden = Condition.function(["selectType"], { (form) -> Bool in
            if let row = form.rowBy(tag: "selectType") as? SelectionButtonRow{
              return row.value == .Two
            }else{
              return false
            }
          })
      })
      
      <<< AskRow(tag: "askRow1").cellUpdate({ (cell, row) in
          row.hidden = Condition.function(["selectType"], { (form) -> Bool in
            if let row = form.rowBy(tag: "selectType") as? SelectionButtonRow{
              return row.value == .Two
            }else{
              return false
            }
          })
        })
      
      +++ Section(){ section in
        section.header = {
          var header = HeaderFooterView<UILabel>(.callback({
            let label = UILabel()
            label.text = "    태그"
            return label
          }))
          header.height = {30}
          return header
        }()
      }
      <<< TagRow(tag: "tagRow")
      <<< SubmitRow()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if let row = form.rowBy(tag: "selectType") as? SelectionButtonRow{
      row.value = .Two
    }
    
  }
}
