//
//  SetupNotificationViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 10..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import FirebaseMessaging

class SetupNotificationViewController: BaseCounterViewController{
  
  var sampleAlert = [(String,String)]()
  
  var isSelectAll: Bool = true
  
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    tableView.dataSource = self
    tableView.delegate = self
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view = tableView
    self.navigationItem.title = "알림설정"
    pushFetch()
  }

  //MARK: - NetWork
  func pushFetch(){
    
    CheeseService.getMyPush { (response) in
      switch response.result{
      case .success(let value):
        guard let data = value.data else {return}
        var sample:[(String,String)] = []
        
        for (name, value) in Mirror(reflecting: data).children {
          guard let name = name, let value = value as? String else { continue }
          sample.append((name,value))
          
          if value == "0"{
            self.isSelectAll = false
          }
        }
        
        self.sampleAlert = sample
        self.tableView.reloadData()
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
  }
  
  func pushUpdate(){
    let message = Messaging.messaging()
    
    var parameter:[String:String] = [:]
    sampleAlert.forEach { (tuple) in
      parameter[tuple.0] = tuple.1
    }
    
    CheeseService.upDateMyPush(parameter: parameter) { (status,data) in
      if status != "200"{
        AlertView(title: data)
          .addChildAction(title: "확인", style: .default, handeler: nil)
          .show()
      }
      if parameter["is_notice"] == "1"{
        message.subscribe(toTopic: "notice")
      }else {
        message.unsubscribe(fromTopic: "notice")
      }
      
      if parameter["is_update"] == "1"{
        message.subscribe(toTopic: "update")
      }else{
        message.unsubscribe(fromTopic: "update")
      }
      
      if parameter["is_event"] == "1"{
        message.subscribe(toTopic: "event")
      }else{
        message.unsubscribe(fromTopic: "event")
      }
      
    }
    self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
  }
  
  
  //MARK: - PushSet
  
  @objc func changePushSetting(_ sender: UISwitch){
    sampleAlert[sender.tag].1 = sender.isOn ? "1" : "0"
    if !sender.isOn{
      self.isSelectAll = false
    } else {
      for i in 0..<sampleAlert.count {
        if sampleAlert[i].1 == "1" {
          self.isSelectAll = true
        } else {
          self.isSelectAll = false
          break
        }
      }
    }
    self.tableView.reloadRows(at:
      [IndexPath(item: sender.tag, section: 1)
        ,IndexPath(item: 0, section: 0)]
      , with: .automatic)
    pushUpdate()
  }
  
  @objc func allChangeAction(_ sender: UISwitch){
    
//    if sender.isOn{
//      for i in 0..<sampleAlert.count {
//        sampleAlert[i].1 = "1"
//      }
//      pushUpdate()
//    }
    if sender.isOn {
      for i in 0..<sampleAlert.count {
        sampleAlert[i].1 = "1"
      }
    } else {
      for i in 0..<sampleAlert.count {
        sampleAlert[i].1 = "0"
      }
    }
    pushUpdate()
  }
  
  //MARK: - Get Korean Language Name
  
  func getKoreaLang(of key:String) -> String{
    switch key {
    case "is_contents":
      return "컨탠츠 추천"
    case "is_survey_done":
      return "질문 만료"
    case "is_reply":
      return "댓글"
    case "is_gold_return":
      return "치즈 판매"
    case "is_notice":
      return "공지사항"
    case "is_update":
      return "업데이트"
    case "is_qna":
      return "1:1문의"
    case "is_event":
      return "이벤트"
    default:
      return ""
    }
  }
}


extension SetupNotificationViewController: UITableViewDelegate{
  
}

extension SetupNotificationViewController: UITableViewDataSource{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return sampleAlert.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = UITableViewCell()
      cell.selectionStyle = .none
      cell.textLabel?.text = "전체설정"
      
      let pushSwitch = UISwitch()
      pushSwitch.addTarget(self, action: #selector(allChangeAction(_:)), for: .valueChanged)
      pushSwitch.isOn = isSelectAll
      cell.accessoryView = pushSwitch
      return cell
    case 1:
      let cell = UITableViewCell()
      cell.selectionStyle = .none
      cell.textLabel?.text = getKoreaLang(of: sampleAlert[indexPath.row].0)
      
      let pushSwitch = UISwitch()
      pushSwitch.tag = indexPath.item
      pushSwitch.addTarget(self, action: #selector(changePushSetting(_:)), for: .valueChanged)
      cell.accessoryView = pushSwitch
      
      pushSwitch.isOn = sampleAlert[indexPath.row].1 == "1"
      return cell
    default:
      return UITableViewCell()
    }
  }
}

