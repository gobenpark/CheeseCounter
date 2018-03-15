//
//  QuestionTableViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 24..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class QuestionTableViewController: UITableViewController, UITextFieldDelegate{
  
  //MARK: - Property
  
  let myPageButton: UIBarButtonItem = {
    let button = UIBarButtonItem()
    button.image = #imageLiteral(resourceName: "btnMypage").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    button.style = .plain
    return button
  }()
  let disposeBag = DisposeBag()
  
  let CellIds = ["setCheese","limit_date","option_gender","option_age","option_addr"]
  
  var questionData = QuestionData()
  
  var dataParameters: DataParameter = DataParameter() {
    didSet{
      questionData.img_status = dataParameters.getImgStatus()
    }
  }
  
  var regionName = ""
  var datePicker : UIDatePicker!
  let emptyTextField = UITextField()
  
  //MARK: - Etc ViewControlers property
  
  let knowHowViewController = QuestionKnowHowViewController()
  let questionSelectGenderVC = QuestionSelectGenderVC()
  let questionSelectAgeVC = QuestionSelectAgeVC()
  let regionSelectVC = QuestionSelectRegionVC()
  
  let optionTexts = ["만료기간","성별","연령","지역"]
  
  var pointData: PointData.Data?
  
  //MARK: - View life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(TitleViewCell.self, forCellReuseIdentifier: TitleViewCell.ID)
    tableView.register(SelectTypeCell.self, forCellReuseIdentifier: SelectTypeCell.ID)
    tableView.register(SelectImageCell.self, forCellReuseIdentifier: SelectImageCell.ID)
    tableView.register(HashTagCell.self, forCellReuseIdentifier: HashTagCell.ID)
    tableView.register(SelectTagViewCell.self, forCellReuseIdentifier: SelectTagViewCell.ID)
    tableView.register(QuestionCheeseSetCell.self, forCellReuseIdentifier: QuestionCheeseSetCell.ID)
    tableView.register(SelectEndDateCell.self, forCellReuseIdentifier: SelectEndDateCell.ID)
    tableView.register(SelectGenderCell.self, forCellReuseIdentifier: SelectGenderCell.ID)
    tableView.register(SelectAgeCell.self, forCellReuseIdentifier: SelectAgeCell.ID)
    tableView.register(SelectCityCell.self, forCellReuseIdentifier: SelectCityCell.ID)
    tableView.register(SelectImageCell2.self, forCellReuseIdentifier: SelectImageCell2.ID)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
    tableView.addGestureRecognizer(tapGesture)
    tableView.separatorStyle = .none
    
    title = "질문"
    self.view = tableView
    self.navigationItem.rightBarButtonItem = UIBarButtonItem()
    
    subViewControllerSet()
    regionFetch()
    
    self.questionData.limit_date = defaultEndDate()
    
    myPageButton.rx.tap
      .map{ _ in return MypageNaviViewController()}
      .subscribe(onNext: { [weak self] (vc) in
        self?.present(vc, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    self.navigationItem.setRightBarButtonItems([myPageButton], animated: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchPoint()
  }
  
  @objc func presentCoachView(){
    let coachView = CoachViewController()
    coachView.imgView.image = coachView.images[2]
    self.present(coachView, animated: true, completion: nil)
  }
  
  @objc fileprivate dynamic func hideKeyBoard(){
    tableView.endEditing(true)
  }
  
  @objc fileprivate dynamic func selectGenderAction(){
    questionSelectGenderVC.modalPresentationStyle = .overCurrentContext
    AppDelegate.instance?.window?.rootViewController?.present(questionSelectGenderVC, animated: true, completion: nil)
  }
  
  @objc fileprivate dynamic func selectAgeAction(){
    questionSelectAgeVC.modalPresentationStyle = .overCurrentContext
    AppDelegate.instance?.window?.rootViewController?.present(questionSelectAgeVC, animated: true, completion: nil)
  }
  
  @objc fileprivate dynamic func selectRegionAction(){
    regionSelectVC.modalPresentationStyle = .overCurrentContext
    AppDelegate.instance?.window?.rootViewController?.present(regionSelectVC, animated: true, completion: nil)
  }
  
  //MAKR: - Init Date
  
  func defaultEndDate() -> String{
    let date = Date(timeIntervalSinceNow: 60*60*24*7)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd"
    return dateFormatter.string(from: date)
  }
  
  //MARK: - SubViewController init
  
  func subViewControllerSet(){
    
    questionSelectGenderVC.gender = self.questionData.option_gender
    questionSelectGenderVC.didTap = {[weak self] (gender) in
      self?.questionData.option_gender = gender
      if let row = self?.CellIds.index(of: "option_gender") {
        self?.tableView.reloadRows(at: [IndexPath(row: row, section: 1)], with: .automatic)
      }
    }
    
    questionSelectAgeVC.ages = questionData.option_age
    questionSelectAgeVC.didTap = {[weak self] (age) in
      
      self?.questionData.option_age = age
      if let row = self?.CellIds.index(of: "option_age") {
        self?.tableView.reloadRows(at: [IndexPath(row: row, section: 1)], with: .automatic)
      }
    }
    
    regionSelectVC.didTap = { [weak self] (regionIndex,regionName) in
      self?.questionData.option_addr = regionIndex
      self?.regionName = regionName
      if let row = self?.CellIds.index(of: "option_addr") {
        self?.tableView.reloadRows(at: [IndexPath(row: row, section: 1)], with: .automatic)
      }
    }
  }
  
  @objc func limitDateSelectAction(_ sender: UIButton){
    self.view.addSubview(emptyTextField)
    emptyTextField.delegate = self
    self.emptyTextField.becomeFirstResponder()
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    pickUpDate(textField: emptyTextField)
  }
  
  //MARK: - DatePicker Actions
  
  func pickUpDate(textField : UITextField){
    
    self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
    self.datePicker.backgroundColor = UIColor.white
    self.datePicker.datePickerMode = UIDatePickerMode.date
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd"
    if let date = dateFormatter.date(from: self.questionData.limit_date){
      self.datePicker.date = date
    }
    textField.inputView = self.datePicker
    
    // ToolBar
    let toolBar = UIToolbar()
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
    toolBar.sizeToFit()
    
    // Adding Button ToolBar
    let doneButton = UIBarButtonItem(title: "✔️", style: .plain, target: self, action: #selector(doneClick))
    doneButton.tintColor = .black
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "❌", style: .plain, target: self, action: #selector(cancelClick))
    cancelButton.tintColor = .black
    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    textField.inputAccessoryView = toolBar
  }
  
  @objc func doneClick(){
    self.emptyTextField.endEditing(true)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd"
    self.questionData.limit_date = dateFormatter.string(from: datePicker.date)
    if let row = self.CellIds.index(of: "limit_date") {
      self.tableView.reloadRows(at: [IndexPath(row: row, section: 1)], with: .automatic)
    }
    emptyTextField.resignFirstResponder()
  }
  @objc func cancelClick(){
    self.emptyTextField.resignFirstResponder()
  }
  
  
  //MARK: - NetWork Fetching
  
  fileprivate func fetchPoint(){
    PointService.getMyPoint { (response) in
      switch response.result{
      case .success(let value):
        self.pointData = value.data
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
  }
  
  fileprivate func regionFetch(){
    CheeseService.getRegion {[weak self] (response) in
      switch response.result{
      case .success(let value):
        guard let datas = value.data else {return}
        self?.sortRegion(regionData: datas)
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
  }
  
  //MARK: - Region Fetching
  func sortRegion(regionData:[RegionData.Data]){
    
    //인덱싱을 위한 변수
    var indexInt = -1
    var indexString = ""
    
    var regionguData:[Int:[gu]] = [:]
    var regionsiData:[si] = []
    
//    regionsiData.sort { (si1, si2) -> Bool in
//      return si1.si > si2.si
//    }
  
    
    regionData.forEach { (data) in
      
      guard let siString = data.si,let guString = data.gu,let id = data.id else {return}
      
      if indexString != siString {
        indexInt += 1
        regionsiData.append(si(si: siString, isSelect: true, buttonSelect: false))
        indexString = siString
        regionguData[indexInt] = []
        regionguData[indexInt]?.append(gu(gu: guString, isSelect: true, id: id))
      } else {
        regionguData[indexInt]?
          .append(gu(gu: guString, isSelect: true, id: id))
      }
    }
    
    var regionIndexString: String = ""
    var regionNameString: String = ""
    
    for (key,value) in regionsiData.enumerated(){
      if value.isSelect == true{
        if let valueData = regionguData[key]{
          for gu in valueData{
            if gu.isSelect == true{
              regionIndexString = regionIndexString + "," + "\(gu.id)"
            }
          }
        }
        regionNameString = regionNameString + "/" + "\(value.si)"
      }
    }
    
    if !regionIndexString.isEmpty{
      regionIndexString.remove(at: regionIndexString.startIndex)
    }
    
    if !regionNameString.isEmpty{
      regionNameString.remove(at: regionIndexString.startIndex)
    }
    self.questionData.option_addr = regionIndexString
    regionSelectVC.regionsiData = regionsiData
    regionSelectVC.regionguData = regionguData
    self.regionName = regionNameString
  }
  
  func moveTabBarGold(){
    self.tabBarController?.selectedIndex = 4
  }
}


//MARK: - UITableViewDataSource

extension QuestionTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 5
    case 1:
      return 0
      if questionData.is_option == "1"{
        return CellIds.count
      } else {
        return 0
      }
    default:
      return 0
    }
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 1{
      let targetView = QuestionTargetView()
      targetView.targetSwitch.isOn = (self.questionData.is_option) == "1" ? true : false
      targetView.tapSwitch = { [weak self] (tap) in
        guard let `self` = self else { return}
        self.questionData.is_option = tap ? "1" : "0"
        if tap{
          self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
        }else {
          self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
        }
      }
      return targetView
    }else if section == 2{
      let uploadView = QuestionUploadButtonView()
      uploadView.uploadTap = { [weak self] in
        guard let `self` = self else {return}
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityView.backgroundColor = #colorLiteral(red: 0.2041754425, green: 0.2073652744, blue: 0.1790439188, alpha: 0.5)
        activityView.frame = UIScreen.main.bounds
        
        self.navigationController?.view.window?.addSubview(activityView)
        activityView.startAnimating()
        var parameter = [String:String]()
        
        if self.questionData.is_option == "1"{
          parameter = self.questionData.getAllParamter()
        }else {
          parameter = self.questionData.defaultParameter()
        }
        
        let complete = self.questionData.isComplete()
        let dataComplete = self.dataParameters.isComplete(type: self.questionData.type)
        if !complete.0{
          activityView.stopAnimating()
          activityView.removeFromSuperview()
          AlertView(title: complete.1).addChildAction(title: "확인", style: .default, handeler: nil).show()
          return
        }else if !dataComplete.0{
          activityView.stopAnimating()
          activityView.removeFromSuperview()
          AlertView(title: complete.1).addChildAction(title: "확인", style: .default, handeler: nil).show()
        }
        CheeseService.dataUpload(parameter: parameter, dataParameter: self.dataParameters){
          [weak self](status,data) in
          guard let `self` = self else {return}
          if status == "200"{
            self.questionData = QuestionData()
            self.questionData.limit_date = self.defaultEndDate()
            self.dataParameters = DataParameter()
            self.regionFetch()
            self.tableView.reloadData()
            activityView.stopAnimating()
            activityView.removeFromSuperview()
            
            AlertView(title: "등록되었습니다.")
              .addChildAction(title: "확인", style: .default, handeler:nil)
              .show()
          }
          else {
            AlertView(title: data)
              .addChildAction(title: "확인", style: .default, handeler: { (_) in
              })
              .show()
            activityView.stopAnimating()
            activityView.removeFromSuperview()
          }
        }
      }
      return uploadView
    }
    return UIView()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      switch indexPath.item {
      case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleViewCell.ID, for: indexPath) as! TitleViewCell
        cell.questionViewController = self
        return cell
      case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectTypeCell.ID, for: indexPath) as! SelectTypeCell
        cell.questionViewController = self
        return cell
      case 2:
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectImageCell.ID, for: indexPath) as! SelectImageCell
        cell.questionViewController = self
        return cell
      case 3:
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectImageCell2.ID, for: indexPath) as! SelectImageCell2
        cell.setBottomBorderColor(color: .lightGray, height: 0.5)
        if questionData.type == "2"{
          cell.isHidden = true
          return cell
        } else {
          cell.questionViewController = self
          return cell
        }
      case 4:
        let cell = tableView.dequeueReusableCell(withIdentifier: HashTagCell.ID, for: indexPath) as! HashTagCell
        cell.setBottomBorderColor(color: .lightGray, height: 0.5)
        cell.questionViewController = self
        return cell
      default:
        break
      }
    case 1:
      switch indexPath.item{
      case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCheeseSetCell.ID, for: indexPath) as! QuestionCheeseSetCell
        cell.questionViewController = self
        cell.currentCalculateView.detailGoldLabel.text = (Int(pointData?.gold ?? "") ?? 0).stringFormattedWithSeparator()+"골드"
        cell.knowHowTap = {[weak self] in
          guard let `self` = self else {return}
          
          self.knowHowViewController.modalPresentationStyle = .overCurrentContext
          AppDelegate.instance?.window?.rootViewController?.present(self.knowHowViewController, animated: true, completion: nil)
        }
        return cell
      case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectEndDateCell.ID, for: indexPath) as! SelectEndDateCell
        cell.subTitleLabel.text = self.questionData.limit_date
        let gesture = UITapGestureRecognizer(target: self, action: #selector(limitDateSelectAction(_:)))
        cell.subTitleLabel.addGestureRecognizer(gesture)
        return cell
        
      case 2:
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectGenderCell.ID, for: indexPath) as! SelectGenderCell
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectGenderAction))
        cell.subTitleLabel.addGestureRecognizer(gesture)
        switch self.questionData.option_gender{
        case "male,female":
          cell.subTitleLabel.text = "남자 / 여자"
        case "male":
          cell.subTitleLabel.text = "남자"
        case "female":
          cell.subTitleLabel.text = "여자"
        default:
          cell.subTitleLabel.text = ""
        }
        return cell
      case 3:
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectAgeCell.ID, for: indexPath) as! SelectAgeCell
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectAgeAction))
        cell.subTitleLabel.addGestureRecognizer(gesture)
        let replaced = questionData.option_age.replacingOccurrences(of: ",", with: "/")
        cell.subTitleLabel.text = replaced
        return cell
      case 4:
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectCityCell.ID, for: indexPath) as! SelectCityCell
        cell.subTitleLabel.text = regionName
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectRegionAction))
        cell.subTitleLabel.addGestureRecognizer(gesture)
        return cell
      default:
        break
      }
    default:
      break
    }
    return UITableViewCell()
  }
}

//MARK: - UITableViewDelegate

extension QuestionTableViewController{
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      switch indexPath.item {
      case 0:
        return 68
      case 1:
        return 62
      case 2:
        return 210
      case 3:
        return questionData.type == "2" ? 0 : 210
      case 4:
        return 98
      case 5:
        return 50
      default:
        return 100
      }
    case 1:
      switch indexPath.item {
      case 0:
        return 340
      case 1...4:
        return 100
      default:
        return 0
      }
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 0
    }else if section == 2{
      return 63
    }else {
      return 0
    }
  }
}
