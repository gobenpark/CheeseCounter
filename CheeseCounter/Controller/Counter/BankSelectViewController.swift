//
//  BankSelectViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 21..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

final class BankSelectViewController: UIViewController{
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }()
  
  var bankCallBackMethod:((String) -> Void)?
  
  let bankNames = [
    "국민","기업","농협","신한(구조흥포함)","우체국","SC(스탠다드차타드)","KEB하나(구외환포함)"
    ,"한국씨티","우리","경남","광주","대구","도이치","부산","산업","수협","전북","제주"
    ,"새마을금고","신용협동조합","홍콩상하이(HSBC)","상호저축은행중앙회","뱅크오브아메리카"
    ,"케이뱅크","제이피모간체이스","비엔피파리바","NH투자증권","유안타증권","KB증권(구현대)"
    ,"미래에셋대우","삼성증권","한국투자증권","교보증권","하이투자증권","HMC투자증권","SK증권"
    ,"한화투자증권","하나금융투자","신한금융투자","유진투자증권","메리츠종합금융증권","신영증권"
    ,"이베스트투자증권","케이프증권(구LIG)","산림조합","부국증권","키움증권","대신증권","동부증권"
    ,"종국공상","KB증권(구KB투자)","펀드온라인코리아","케이티비투자증권"
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view = tableView
    let barbutton = UIBarButtonItem(image: #imageLiteral(resourceName: "popup_close@1x"), style: .plain, target: self, action: #selector(dismissAction))
    barbutton.tintColor = .black
    self.navigationItem.rightBarButtonItem = barbutton
    self.navigationItem.title = "은행선택"
  }
  
  func dismissAction(){
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }
}

extension BankSelectViewController: UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let callBack = bankCallBackMethod else {return}
    callBack(bankNames[indexPath.item])
    dismissAction()
  }
}

extension BankSelectViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return bankNames.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
    cell.accessoryType = .disclosureIndicator
    cell.selectionStyle = .none
    cell.textLabel?.text = bankNames[indexPath.row]
    return cell
  }
}
