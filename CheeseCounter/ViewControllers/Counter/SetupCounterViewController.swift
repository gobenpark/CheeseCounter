////
////  SetupPageViewController.swift
////  CheeseCounter
////
////  Created by xiilab on 2017. 3. 14..
////  Copyright © 2017년 xiilab. All rights reserved.
////
//
//import UIKit
//
//class SetupCounterViewController: UITableViewController
//{
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    self.navigationItem.title = "설정"
//  }
//  
//  func logOutAction(){
//    let alertVC = UIAlertController(title: "로그아웃",
//                                    message: "로그아웃 하시면\n서비스의 기능이 제한됩니다.\n로그아웃 하시겠습니까?",
//                                    preferredStyle: UIAlertControllerStyle.alert)
//    
//    let alertAction1 = UIAlertAction(title: "예", style: .default, handler: { (action) in
//      UserService.isLogin = false
//      KOSession.shared().logoutAndClose { [weak self] (success, error) -> Void in
//        _ = self?.navigationController?.popViewController(animated: true)
//      }
//    })
//    let alertAction2 = UIAlertAction(title: "아니오", style: .destructive, handler: nil)
//    
//    alertVC.addAction(alertAction1)
//    alertVC.addAction(alertAction2)
//    self.present(alertVC, animated: true, completion: nil)
//  }
//  
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    self.navigationController?.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 0.9978943467, green: 0.8484466672, blue: 0.1216805503, alpha: 1), height: 2)
//  }
//  
//  override func viewWillDisappear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    self.navigationController?.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), height: 2)
//  }
//}
//
////MARK: - Datasource
//extension SetupCounterViewController {
//  
//  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    switch section {
//    case 0:
//      return "프로필 설정"
//    case 1:
//      return "알림 설정"
//    case 2:
//      return "서비스 지원"
//    case 3:
//      return "서비스 정보"
//    default:
//      return ""
//    }
//  }
//  override func numberOfSections(in tableView: UITableView) -> Int {
//    return 5
//  }
//  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    switch section  {
//    case 0,1,3:
//      return 1
//    case 2:
//      return 3
//    case 4:
//      return 2
//    default:
//      return 0
//    }
//  }
//  
//  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = UITableViewCell(style: .value1, reuseIdentifier: "cellid")
//    cell.accessoryType = .disclosureIndicator
//    cell.selectionStyle = .none
//    cell.textLabel?.textColor = .black
//    
//    switch indexPath.section{
//    case 0:
//      cell.textLabel?.text = "프로필 설정"
//    case 1:
//      cell.textLabel?.text = "알림설정"
//    case 2:
//      switch indexPath.row {
//      case 0:
//        cell.textLabel?.text = "공지사항"
//      case 1:
//        cell.textLabel?.text = "이용약관 및 개인정보 취급방침"
//      case 2:
//        cell.textLabel?.text = "1 : 1 문의"
//      default:
//        break
//      }
//      
//    case 3:
//      cell.textLabel?.text = "버전 정보"
//    case 4:
//      if indexPath.row == 0{
//        cell.textLabel?.text = "로그아웃"
//        cell.textLabel?.textColor = #colorLiteral(red: 1, green: 0.5882352941, blue: 0, alpha: 1)
//      } else {
//        cell.textLabel?.text = "회원탈퇴"
//        cell.textLabel?.textColor = #colorLiteral(red: 1, green: 0.5882352941, blue: 0, alpha: 1)
//      }
//    default:
//      break
//    }
//    return cell
//  }
//  
//  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    return 50
//  }
//  
//}
//
//extension SetupCounterViewController {
//  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    switch indexPath.section {
//    case 0:
//      self.navigationController?.pushViewController(SetupProfileViewController(), animated: true)
//    case 1:
//      self.navigationController?.pushViewController(SetupNotificationViewController(), animated: true)
//      break
//    case 2:
//      switch indexPath.row {
//      case 0:
//        self.navigationController?.pushViewController(NoticeViewController(), animated: true)
//      case 1:
//        self.navigationController?.pushViewController(personalInfoViewController(), animated: true)
//      case 2:
//        self.navigationController?.pushViewController(QnAViewController(), animated: true)
//      default:
//        break
//      }
//    case 3:
//      self.navigationController?.pushViewController(VersionViewController(), animated: true)
//      break
//    case 4:
//      switch indexPath.row {
//      case 0:
//        logOutAction()
//      case 1:
//        CheeseService.getIsSecession { (data) in
//          if data == "1"{
//            self.navigationController?.pushViewController(DropOutConfirmViewController(), animated: true)
//          } else{
//            self.navigationController?.pushViewController(DropOutViewController(), animated: true)
//          }
//        }
//      default:
//        break
//      }
//    default:
//      break
//    }
//  }
//}

