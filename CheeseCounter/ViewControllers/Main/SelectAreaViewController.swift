//
//  QuestionSelectRegionVC.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 4. 9..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class SelectAreaViewController: BaseSetupViewController{
  
  var didTap:((String) -> Void)?
  var regionData:[RegionData.Data] = []{
    didSet{
      var indexInt = -1
      var indexString = ""
      regionData.forEach { (data) in
        guard let siString = data.si,let guString = data.gu,let id = data.id else {return}
        if indexString != siString {
          indexInt += 1
          regionsiData.append(si(si: siString, isSelect: false, buttonSelect: false))
          indexString = siString
          regionAllData[indexInt] = []
          regionAllData[indexInt]?.append(gu(gu: guString, isSelect: false, id: id))
        } else {
          tempData[siString] = ""
          regionAllData[indexInt]?
            .append(gu(gu: guString, isSelect: false, id: id))
        }
      }
      self.citySelectView.reloadData()
      self.guSelectView.reloadData()
    }
  }
  
  var regionAllData:[Int:[gu]] = [:]
  var tempData:[String:String] = [:]
  var regionsiData:[si] = []
  
  var siIndex:Int = 0{
    didSet{
      self.guSelectView.reloadData()
    }
  }
  
  let mainLabel: UILabel = {
    let label = UILabel()
    label.text = "현재 살고 계신 지역을 선택해 주세요."
    label.font = UIFont.boldSystemFont(ofSize: 17)
    return label
  }()
  
  lazy var citySelectView: UITableView = {
    let tableView = UITableView()
    tableView.dataSource = self
    tableView.rowHeight = 60
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    tableView.register(SelectRegionCell.self, forCellReuseIdentifier: "SelectRegionCell")
    let swipe = UISwipeGestureRecognizer(target: self, action: #selector(empty))
    swipe.direction = .left
    tableView.addGestureRecognizer(swipe)
    tableView.tag = 0
    return tableView
  }()
  
  lazy var guSelectView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    tableView.dataSource = self
    tableView.register(SelectRegionCell.self, forCellReuseIdentifier: "SelectRegionCell")
    tableView.rowHeight = 60
    let swipe = UISwipeGestureRecognizer(target: self, action: #selector(empty))
    swipe.direction = .left
    tableView.addGestureRecognizer(swipe)
    tableView.tag = 1
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.titleLabel.text = "회원정보 추가"
    isdisableScroll = true
    self.view.addSubview(mainLabel)
    self.view.addSubview(citySelectView)
    self.view.addSubview(guSelectView)
    fetch()
    
    mainLabel.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(20)
      make.centerX.equalToSuperview()
    }
    
    citySelectView.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.top.equalTo(mainLabel.snp.bottom).offset(40)
      make.right.equalTo(self.view.snp.centerX).inset(-2)
      make.bottom.equalToSuperview().inset(100)
    }
    
    guSelectView.snp.makeConstraints { (make) in
      make.right.equalToSuperview()
      make.top.equalTo(citySelectView)
      make.left.equalTo(self.view.snp.centerX).inset(2)
      make.bottom.equalTo(citySelectView)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if self.userSetupViewController?.signUp.age == nil{
      AlertView(title: "알림", message: "나이를 입력해주세요", preferredStyle: .alert)
        .addChildAction(title: "확인", style: .default, handeler: { (_) in
          self.userSetupViewController?.setUpPageViewController.scrollToViewController(index: 3)
        })
        .show()
    }

  }
  
  @objc func empty(){}
  
  func fetch(){
    CheeseService.getRegion { (response) in
      switch response.result{
      case .success(let value):
        guard let datas = value.data else {return}
        self.regionData = datas
        self.guSelectView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
  }
  @objc fileprivate dynamic func commitAction(){
    var regionString = ""
    
    for (key,value) in regionsiData.enumerated(){
      if value.isSelect == true{
        if let valueData = regionAllData[key]{
          for gu in valueData{
            if gu.isSelect == true{
              regionString = regionString + "," + "\(gu.id)"
            }
          }
        }
      }
    }
    
    if !regionString.isEmpty{
      regionString.remove(at: regionString.startIndex)
    }
  }
}


extension SelectAreaViewController: UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch tableView.tag{
    case 0:
      return regionsiData.count
    case 1:
      return regionAllData[siIndex]?.count ?? 0
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SelectRegionCell", for: indexPath) as! SelectRegionCell
    switch tableView.tag {
    case 0:
      cell.regionButton.setTitle(regionsiData[indexPath.row].si, for: .normal)
      cell.regionButton.tag = indexPath.row
      cell.regionButton.addTarget(self, action: #selector(tableView(cityButton:)), for: .touchUpInside)
      cell.regionButton.isSelected = regionsiData[indexPath.row].isSelect
      return cell
    case 1:
      cell.regionButton.setTitle(regionAllData[siIndex]?[indexPath.row].gu, for: .normal)
      cell.regionButton.tag = indexPath.row
      cell.regionButton.addTarget(self, action: #selector(tableView(guButton:)), for: .touchUpInside)
      cell.regionButton.isSelected = regionAllData[siIndex]?[indexPath.row].isSelect ?? true
      return cell
    default:
      return cell
    }
  }
  
  @objc func tableView(cityButton: UIButton){
    //이전 시의 구 버튼 모두 false 만들기
    guard let count = self.regionAllData[siIndex]?.count else {return}
    for i in 0 ..< count{
      self.regionAllData[siIndex]?[i].isSelect = false
    }
    cityButton.isSelected = true
    
    self.siIndex = cityButton.tag
    
    if cityButton.isSelected{
      for i in 0..<regionsiData.count{
        regionsiData[i].isSelect = false
      }
      
      cityButton.isSelected = true
      
      self.regionsiData[cityButton.tag].isSelect = cityButton.isSelected
      self.userSetupViewController?.signUp.addr1 = cityButton.title(for: .normal)
      self.userSetupViewController?.signUp.addr2 = nil
      // commitAction()
      cityButton.backgroundColor = #colorLiteral(red: 0.9983282685, green: 0.5117852092, blue: 0.2339783907, alpha: 1)
    } else {
      self.regionsiData[cityButton.tag].isSelect = cityButton.isSelected
      self.userSetupViewController?.signUp.addr1 = nil
      guard let count = self.regionAllData[siIndex]?.count else {return}
      for i in 0 ..< count{
        self.regionAllData[siIndex]?[i].isSelect = false
      }
    }
    self.citySelectView.reloadData()
  }
  
  @objc func tableView(guButton: UIButton){
    guButton.isSelected = guButton.isSelected ? false : true
    if guButton.isSelected{
      
      guard let count = regionAllData[siIndex]?.count else {return}
      for i in 0..<count{
        regionAllData[siIndex]?[i].isSelect = false
      }
      guButton.isSelected = true
      regionAllData[siIndex]?[guButton.tag].isSelect = guButton.isSelected
      self.userSetupViewController?.signUp.addr1 = regionsiData[siIndex].si
      self.userSetupViewController?.signUp.addr2 = guButton.title(for: .normal)
      guButton.backgroundColor = #colorLiteral(red: 0.9983282685, green: 0.5117852092, blue: 0.2339783907, alpha: 1)
      isdisableScroll = false
      self.userSetupViewController?.setUpPageViewController.scrollToViewController(index: 5)
    } else {
      self.regionAllData[siIndex]?[guButton.tag].isSelect = false
      self.userSetupViewController?.signUp.addr2 = nil
      guButton.backgroundColor = .white
    }
    self.guSelectView.reloadData()
  }
  
  @objc override dynamic func swipeAction(){
    AlertView(title: "알림", message: "지역을 하나이상 선택해 주세요.", preferredStyle: .alert)
      .addChildAction(title: "확인", style: .default, handeler: nil)
      .show()
  }
}

class SelectRegionCell: UITableViewCell{
  
  lazy var regionButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .lightGray
    button.setTitleColor(.black, for: .normal)
    button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_5_nomal@1x"), for: .normal)
    button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_5_select@1x"), for: .selected)
    button.setTitleColor(.white, for: .selected)
    return button
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.contentView.addSubview(regionButton)
    self.selectionStyle = .none
    self.backgroundColor = .clear
    regionButton.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if regionButton.isSelected{
      regionButton.backgroundColor = #colorLiteral(red: 0.9983282685, green: 0.5117852092, blue: 0.2339783907, alpha: 1)
    } else {
      regionButton.backgroundColor = .white
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
