//
//  ConfigViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 23..
//  Copyright © 2018년 xiilab. All rights reserved.
//  설정 메인

import UIKit
import Eureka
import Carte

final class ConfigViewController: FormViewController{
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    automaticallyAdjustsScrollViewInsets = false
    title = "설정"
    form +++ Section("프로필 설정")
      <<< LabelRow().cellSetup({ (cell, row) in
        row.title = "프로필 설정"
        cell.accessoryType = .disclosureIndicator
      }).onCellSelection({[weak self] (cell, row) in
        self?.navigationController?.pushViewController(SetupProfileViewController(), animated: true)
      })
      <<< LabelRow().cellSetup({ (cell, row) in
        row.title = "추천인 코드"
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: cell.bounds.height))
        label.textColor = .gray
        label.text = UserData.instance.userID.components(separatedBy: "_")[1]
        label.sizeToFit()
        label.textAlignment = .right
        cell.accessoryView = label
      })
    
    +++ Section("알림 설정")
      <<< LabelRow().cellSetup({ (cell, row) in
        row.title = "알림 설정"
        cell.accessoryType = .disclosureIndicator
      }).onCellSelection({[weak self] (cell, row) in
        self?.navigationController?.pushViewController(SetupNotificationViewController(), animated: true)
      })
      
    
    +++ Section("서비스 지원")
      <<< LabelRow().cellSetup({ (cell, row) in
        row.title = "공지사항"
        cell.accessoryType = .disclosureIndicator
      }).onCellSelection({[weak self] (cell, row) in
        self?.navigationController?.pushViewController(NoticeViewController(), animated: true)
      })
      <<< LabelRow().cellSetup({ (cell, row) in
        row.title = "이벤트"
        cell.accessoryType = .disclosureIndicator
      }).onCellSelection({[weak self] (cell, row) in
        self?.navigationController?.pushViewController(CounterEventViewController(), animated: true)
      })
      <<< LabelRow().cellSetup({ (cell, row) in
        row.title = "이용약관 및 개인정보 취급방침"
        cell.accessoryType = .disclosureIndicator
      }).onCellSelection({[weak self] (cell, row) in
        self?.navigationController?.pushViewController(PrivacyViewController(), animated: true)
      })
      <<< LabelRow().cellSetup({ (cell, row) in
        row.title = "1:1 문의"
        cell.accessoryType = .disclosureIndicator
      }).onCellSelection({[weak self] (cell, row) in
        self?.navigationController?.pushViewController(QnAViewController(), animated: true)
      })
    
    +++ Section("서비스 정보")
      <<< LabelRow().cellSetup({ (cell, row) in
        row.title = "오픈소스 라이센스 (OSS License)"
        cell.accessoryType = .disclosureIndicator
      }).onCellSelection({[weak self] (cell, row) in
        self?.navigationController?.pushViewController(CarteViewController(), animated: true)
      })
      <<< LabelRow().cellSetup({ (cell, row) in
        row.title = "버전정보"
        cell.accessoryType = .disclosureIndicator
      }).onCellSelection({[weak self] (cell, row) in
        self?.navigationController?.pushViewController(VersionViewController(), animated: true)
      })
    
    +++ Section()
      <<< LabelRow().cellSetup({ (cell, row) in
        row.title = "로그아웃"
        cell.accessoryType = .disclosureIndicator
      }).cellUpdate({ (cell, row) in
        cell.detailTextLabel?.textColor = #colorLiteral(red: 1, green: 0.4, blue: 0.1882352941, alpha: 1)
      }).onCellSelection({ (cell, row) in
        KOSession.shared().logoutAndClose(completionHandler: nil)
      })
      <<< LabelRow().cellSetup({ (cell, row) in
        row.title = "회원탈퇴"
        cell.detailTextLabel?.textColor = #colorLiteral(red: 1, green: 0.4, blue: 0.1882352941, alpha: 1)
        cell.accessoryType = .disclosureIndicator
      }).onCellSelection({[weak self] (cell, row) in
        self?.navigationController?.pushViewController(DropOutViewController(), animated: true)
      })
    
    tableView.reloadData()
  }
}
