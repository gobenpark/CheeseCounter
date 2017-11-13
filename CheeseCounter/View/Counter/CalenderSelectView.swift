//
//  CalenderSelectView.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 18..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class CalendarSelectView: UIView, UITextViewDelegate{
  
  var yearPicker: PickerView!
  var monthPicker: PickerView!
  let emptyTextView = UITextView()
  var fetchData:(([String:String]) -> Void)?{
    didSet{
      fetchData?(["year":"\(year ?? 0)","month":"\(month ?? 0)"])
    }
  }
  var year: Int?
  var month: Int?
  
  lazy var yearButton: UIButton = {
    let button = UIButton()
    button.tag = 0
    button.backgroundColor = #colorLiteral(red: 1, green: 0.848323524, blue: 0.005472274031, alpha: 1)
    button.titleLabel?.font = UIFont.CheeseFontMedium(size: 15)
    button.setImage(#imageLiteral(resourceName: "arrow_drop@1x"), for: .normal)
    button.semanticContentAttribute = .forceRightToLeft
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.textAlignment = .left
    button.addTarget(self, action: #selector(picker(_:)), for: .touchUpInside)
    return button
  }()
  
  lazy var monthButton: UIButton = {
    let button = UIButton()
    button.tag = 1
    button.backgroundColor = #colorLiteral(red: 1, green: 0.848323524, blue: 0.005472274031, alpha: 1)
    button.titleLabel?.font = UIFont.CheeseFontMedium(size: 15)
    button.setImage(#imageLiteral(resourceName: "arrow_drop@1x"), for: .normal)
    button.semanticContentAttribute = .forceRightToLeft
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(picker(_:)), for: .touchUpInside)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    addSubview(yearButton)
    addSubview(monthButton)
    NotificationCenter.default.addObserver(self, selector: #selector(fetching), name: NSNotification.Name(rawValue: "reloadSubView"), object: nil)
    
    yearButton.snp.remakeConstraints { (make) in
      make.left.equalToSuperview().inset(10)
      make.bottom.equalToSuperview().inset(10)
      make.right.equalTo(self.snp.centerX).inset(-5)
      make.top.equalToSuperview().inset(10)
    }
    
    monthButton.snp.remakeConstraints { (make) in
      make.left.equalTo(self.snp.centerX).inset(5)
      make.right.equalToSuperview().inset(10)
      make.top.equalToSuperview().inset(10)
      make.bottom.equalToSuperview().inset(10)
    }
    
    self.yearPicker = PickerView(frame:CGRect(x: 0, y: 0, width: self.frame.size.width, height: 216))
    self.yearPicker.isYear = true
    self.monthPicker = PickerView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 216))
    self.monthPicker.isYear = false
    yearPicker.calendarSelectView = self
    monthPicker.calendarSelectView = self
    yearPicker.setToday()
    monthPicker.setToday()
  }
  
  @objc func fetching(){
    self.fetchData?(["year":"\(year ?? 0)","month":"\(month ?? 0)"])
  }
  
  @objc func picker(_ sender: UIButton){
    self.addSubview(emptyTextView)
    emptyTextView.tag = sender.tag
    self.pickUpDate(textField: emptyTextView)
    emptyTextView.becomeFirstResponder()
  }
  
  func pickUpDate(textField : UITextView){
    self.yearPicker.backgroundColor = .white
    self.monthPicker.backgroundColor = .white
    textField.inputView = textField.tag == 0 ? yearPicker : monthPicker
    
    // ToolBar
    let toolBar = UIToolbar()
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
    toolBar.sizeToFit()
    
    // Adding Button ToolBar
    let doneButton = UIBarButtonItem(title: "✔️", style: .plain, target: self, action: #selector(doneClick))
    doneButton.tag = textField.tag
    doneButton.tintColor = .black
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "❌", style: .plain, target: self, action: #selector(cancelClick))
    cancelButton.tintColor = .black
    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    textField.inputAccessoryView = toolBar
  }
  
  @objc func doneClick(_ sender: UIBarButtonItem) {
    if sender.tag == 0{
      self.yearButton.setTitle("\(year ?? 0)년", for: .normal)
    }else if sender.tag == 1{
      self.monthButton.setTitle("\(month ?? 0)월", for: .normal)
    }
    emptyTextView.resignFirstResponder()
    guard let fetch = fetchData else {return}
    fetch(["year":"\(year ?? 0)","month":"\(month ?? 0)"])
  }
  
  func startButtonSetting(){
    self.yearButton.setTitle("\(year ?? 0)년", for: .normal)
    self.monthButton.setTitle("\(month ?? 0)월", for: .normal)
    guard let fetch = fetchData else {return}
    fetch(["year":"\(year ?? 0)","month":"\(month ?? 0)"])
  }
  
  @objc func cancelClick() {
    emptyTextView.resignFirstResponder()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class PickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource{
  
  var yearData:[Int] = []
  var monthData:[Int] = []
  var calendarSelectView: CalendarSelectView?
  var isYear:Bool = true
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.delegate = self
    self.dataSource = self
    for i in 2007...2027{
      yearData.append(i)
    }
    
    for i in 1...12{
      monthData.append(i)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setToday(){
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .full
    if isYear{
      dateFormatter.dateFormat = "YYYY"
      let year = dateFormatter.string(from: date).components(separatedBy: ".")[0]
      guard let yearIndex = yearData.index(of: Int(year) ?? 0) else {return}
      self.selectRow(yearIndex, inComponent: 0, animated: true)
      guard let homeView = calendarSelectView else {return}
      homeView.year = yearData[yearIndex]
      homeView.startButtonSetting()
      
    }else {
      dateFormatter.dateFormat = "MM"
      let month = dateFormatter.string(from: date).components(separatedBy: ".")[0]
      guard let monthIndex = monthData.index(of: Int(month) ?? 0) else {return}
      self.selectRow(monthIndex, inComponent: 0, animated: true)
      guard let homeView = calendarSelectView else {return}
      homeView.month = monthData[monthIndex]
      homeView.startButtonSetting()
      
    }
    
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if isYear{
      return yearData.count
    }else{
      return monthData.count
    }
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if isYear{
      return "\(yearData[row])년"
    }else {
      return "\(monthData[row])월"
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    guard let homeView = calendarSelectView else {return}
    if isYear{
      homeView.year = yearData[row]
    }else {
      homeView.month = monthData[row]
    }
    
  }
}

