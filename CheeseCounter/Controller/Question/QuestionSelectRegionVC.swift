//
//  QuestionSelectRegionVC.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 4. 9..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class QuestionSelectRegionVC: UIViewController{
  
  var didTap:((String,String) -> Void)?
  
  var regionguData:[Int:[gu]] = [:]{
    didSet{
      self.guSelectView.reloadData()
      self.citySelectView.reloadData()
    }
  }
  
  var regionsiData:[si] = []{
    didSet{
      self.citySelectView.reloadData()
    }
  }
  
  var siIndex:Int = 0{
    didSet{
      self.guSelectView.reloadData()
    }
  }
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "지역 (중복 가능)"
    label.sizeToFit()
    label.font = UIFont.CheeseFontBold(size: 16)
    return label
  }()
  
  lazy var cityAllButton: UIButton = {
    let button = UIButton()
    button.setTitle("전체해제", for: .selected)
    button.setTitle("전체선택", for: .normal)
    button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_5_nomal@1x"), for: .normal)
    button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_5_select@1x"), for: .selected)
    button.setTitleColor(.white, for: .selected)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(selectAllCityRegion(_:)), for: .touchUpInside)
    button.isSelected = true
    return button
  }()
  
  let guAllButton: UIButton = {
    let button = UIButton()
    button.setTitle("전체해제", for: .selected)
    button.setTitle("전체선택", for: .normal)
    button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_5_nomal@1x"), for: .normal)
    button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_5_select@1x"), for: .selected)
    button.setTitleColor(.white, for: .selected)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(selectGuAllRegion(_:)), for: .touchUpInside)
    button.isSelected = true
    return button
  }()
  
  lazy var citySelectView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = 60
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    tableView.register(RegionCell.self, forCellReuseIdentifier: "RegionCell")
    tableView.tag = 0
    return tableView
  }()
  
  lazy var guSelectView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(RegionCell.self, forCellReuseIdentifier: "RegionCell")
    tableView.rowHeight = 60
    tableView.tag = 1
    return tableView
  }()
  
  lazy var commitButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(#imageLiteral(resourceName: "btn_gradation@1x"), for: .normal)
    button.setTitle("확인", for: .normal)
    button.addTarget(self, action: #selector(commitButtonAction(_:)), for: .touchUpInside)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor(red: 254/255, green: 220/255, blue: 25/255, alpha: 0.8)
    self.view.addSubview(titleLabel)
    self.view.addSubview(cityAllButton)
    self.view.addSubview(guAllButton)
    self.view.addSubview(citySelectView)
    self.view.addSubview(guSelectView)
    self.view.addSubview(commitButton)
    
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self.view.snp.topMargin).inset(35)
      make.centerX.equalToSuperview()
    }
    
    cityAllButton.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.right.equalTo(self.view.snp.centerX).inset(-20)
      make.top.equalTo(titleLabel.snp.bottom).offset(15)
      make.height.equalTo(50)
    }
    
    guAllButton.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(20)
      make.left.equalTo(self.view.snp.centerX).inset(25)
      make.top.equalTo(cityAllButton)
      make.height.equalTo(cityAllButton)
    }
    
    citySelectView.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.top.equalTo(cityAllButton.snp.bottom).offset(20)
      make.right.equalTo(self.view.snp.centerX).inset(-2)
      make.bottom.equalToSuperview().inset(80)
    }
    
    guSelectView.snp.makeConstraints { (make) in
      make.right.equalToSuperview()
      make.top.equalTo(citySelectView)
      make.left.equalTo(self.view.snp.centerX).inset(2)
      make.bottom.equalTo(citySelectView)
    }
    
    commitButton.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview().inset(10)
      make.left.equalToSuperview().inset(20)
      make.height.equalTo(50)
      make.right.equalToSuperview().inset(20)
    }
  }
  
  fileprivate dynamic func selectAllCityRegion(_ sender: UIButton){
    
    if sender.isSelected{
      for i in 0..<regionsiData.count{
        regionsiData[i].isSelect = false
        for j in 0..<(regionguData[i]?.count ?? 0){
          regionguData[i]?[j].isSelect = false
        }
      }
    } else {
      for i in 0..<regionsiData.count{
        regionsiData[i].isSelect = true
        for j in 0..<(regionguData[i]?.count ?? 0){
          regionguData[i]?[j].isSelect = true
        }
      }
    }
    
    sender.isSelected = sender.isSelected ? false : true
    self.guAllButton.isSelected = sender.isSelected
    self.citySelectView.reloadData()
    self.guSelectView.reloadData()
  }
  
  fileprivate dynamic func selectGuAllRegion(_ sender: UIButton){
    
    guard let count = regionguData[siIndex]?.count else {return}
    
    if sender.isSelected{
      for i in 0..<count{
        regionguData[siIndex]?[i].isSelect = false
      }
      self.regionsiData[siIndex].isSelect = false
    }else {
      for i in 0..<count{
        regionguData[siIndex]?[i].isSelect = true
      }
      self.regionsiData[siIndex].isSelect = true
    }
    
    sender.isSelected = sender.isSelected ? false : true
    self.guSelectView.reloadData()
  }
  
  fileprivate dynamic func commitButtonAction(_ sender: UIButton){
    
    var regionIndexString = ""
    var regionNameString = ""
    
    for (key,value) in regionsiData.enumerated(){
      if value.isSelect == true{
        if let valueData = regionguData[key]{
          for gu in valueData{
            if gu.isSelect == true{
              regionIndexString = regionIndexString + "," + "\(gu.id)"
//              regionNameString = regionNameString + "," + "\(gu.gu)"
            }
          }
        }
      }
    }
    
    for (key,value) in regionguData{
      let gudatas = value.filter({ (gu) -> Bool in
        return gu.isSelect
      })
      
      if !gudatas.isEmpty{
        regionNameString = regionNameString + "," + "\(regionsiData[key].si)"
      }
    }
    
    if !regionIndexString.isEmpty{
      regionIndexString.remove(at: regionIndexString.startIndex)
    }
    
    if !regionNameString.isEmpty{
      regionNameString.remove(at: regionIndexString.startIndex)
    }
    
    
    guard let tap = didTap else { return }
    tap(regionIndexString,regionNameString)
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }
  
  func calculateGuCount(item:Int) -> Int{
    var count = 0
    regionguData[item]?.forEach({ (gu) in
      if gu.isSelect == true {
        count += 1
      }
    })
    return count
  }
}


extension QuestionSelectRegionVC: UITableViewDelegate{
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
}

extension QuestionSelectRegionVC: UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch tableView.tag{
    case 0:
      return regionsiData.count
    case 1:
      return regionguData[siIndex]?.count ?? 0
    default:
      return 0
    }
  }
  
  
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "RegionCell", for: indexPath) as! RegionCell
    switch tableView.tag {
    case 0:
      cell.regionButton.setTitle(regionsiData[indexPath.row].si + "(\(calculateGuCount(item: indexPath.item)))", for: .normal)
      cell.regionButton.tag = indexPath.row
      cell.regionButton.isSelected = regionsiData[indexPath.row].buttonSelect
      cell.regionButton.addTarget(self, action: #selector(tableView(cityButton:)), for: .touchUpInside)
      return cell
    case 1:
      cell.regionButton.setTitle(regionguData[siIndex]?[indexPath.row].gu, for: .normal)
      cell.regionButton.tag = indexPath.row
      cell.regionButton.addTarget(self, action: #selector(tableView(guButton:)), for: .touchUpInside)
      cell.regionButton.isSelected = regionguData[siIndex]?[indexPath.row].isSelect ?? true
      return cell
    default:
      return cell
    }
  }
  
  //MARK: - CITY BUTTON
  func tableView(cityButton: UIButton){
    
    self.siIndex = cityButton.tag
    
    for i in 0..<self.regionsiData.count{
      self.regionsiData[i].buttonSelect = false
    }
    
    self.regionsiData[siIndex].buttonSelect = true
  }
  
  //MARK: - GU BUTTON
  func tableView(guButton: UIButton){
    
    guButton.isSelected = guButton.isSelected ? false : true
    if guButton.isSelected{
      self.regionguData[self.siIndex]?[guButton.tag].isSelect = guButton.isSelected
      guButton.isSelected = true
      self.regionsiData[self.siIndex].isSelect = true
    } else {
      self.regionguData[self.siIndex]?[guButton.tag].isSelect = guButton.isSelected
      guButton.isSelected = false
    }
    
    var selectGuCount = 0
    
    regionguData[siIndex]?.forEach({ (gu) in
      if gu.isSelect == false {
        self.guAllButton.isSelected = false
      }else {
        self.regionsiData[self.siIndex].isSelect = true
        selectGuCount += 1
      }
    })

    if selectGuCount == (regionguData[siIndex]?.count ?? 0){
      self.guAllButton.isSelected = true
    }
    if selectGuCount == 0 {
      self.regionsiData[self.siIndex].isSelect = false
    }
  }
}

class RegionCell: UITableViewCell{
  
  lazy var regionButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_5_nomal@1x"), for: .normal)
    button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_5_select@1x"), for: .selected)
    button.setTitleColor(.black, for: .normal)
    button.setTitleColor(.white, for: .selected)
    return button
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.contentView.addSubview(regionButton)
    self.selectionStyle = .none
    self.backgroundColor = .clear
    regionButton.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20))
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct si{
  var si: String
  var isSelect: Bool = true
  var buttonSelect: Bool = false
}

struct gu {
  var gu: String
  var isSelect: Bool = true
  var id: String
}



