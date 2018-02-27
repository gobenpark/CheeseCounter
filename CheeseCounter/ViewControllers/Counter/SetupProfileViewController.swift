//
//  SetupProfileViewController.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 4. 4..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

final class SetupProfileViewController: BaseCounterViewController {
  
  var userData: UserResult.Data?
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CounterProfileCell.self, forCellReuseIdentifier: CounterProfileCell.ID)
    tableView.register(SubProfileCell.self, forCellReuseIdentifier: SubProfileCell.ID)
    return tableView
  }()
  
  let titles = ["별명","성별","연령","지역"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.navigationItem.title = "프로필"
    self.view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    fetch()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.tableView.setNeedsLayout()
    self.tableView.layoutIfNeeded()
  }
  
  func fetch(){
    UserService.getMyInfo { (response) in
      switch response.result{
      case .success(let value):
        self.userData = value.data
        self.tableView.reloadData()
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
  }
}


extension SetupProfileViewController: UITableViewDelegate{
  
}

extension SetupProfileViewController: UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return titles.count+1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: CounterProfileCell.ID, for: indexPath) as! CounterProfileCell
      guard let data = userData else {return cell}
      let url = URL(string: data.img_url ?? "")
      cell.imgView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "profile_medium"), options: nil, progressBlock: nil, completionHandler: nil)
      return cell
    case 1...4:
      let cell = tableView.dequeueReusableCell(withIdentifier: SubProfileCell.ID, for: indexPath) as! SubProfileCell
      cell.titleLabel.text = titles[indexPath.row - 1]
      cell.subTitleLabel.tag = (indexPath.item - 1)
      cell.fetchProfileData(data: userData)
      return cell
    default:
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.row {
    case 0:
      return 200
    default:
      return 50
    }
  }
}

