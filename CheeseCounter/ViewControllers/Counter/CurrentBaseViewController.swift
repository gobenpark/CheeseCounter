//
//  CurrentBaseViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 5. 31..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class CurrentBaseViewController: UIViewController{
  
  var counterMenuBar: CounterMenuBar!
  
  var parameter: [String:String] = [:]
  lazy var picker: UIDatePicker = {
    let picker = UIDatePicker()
    picker.datePickerMode = UIDatePickerMode.date
    return picker
  }()
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.isPagingEnabled = true
    collectionView.delegate = self
    return collectionView
  }()

  override func viewDidLoad(){
    super.viewDidLoad()
    
    self.view.addSubview(collectionView)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
    collectionView.addGestureRecognizer(tapGesture)
    setUp()
  }
  
  @objc fileprivate dynamic func hideKeyBoard(_ sedner: UIGestureRecognizer){
    collectionView.endEditing(true)
  }
  
  func scrollToMenuIndex(_ menuIndex: Int) {
    let indexPath = IndexPath(item: menuIndex, section: 0)
    collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    counterMenuBar.bottomConstraint?.update(offset: (scrollView.contentOffset.x / CGFloat(counterMenuBar.menuString.count)))
  }
  
  
  func yearPickerAction(_ sender: UIButton){
    
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.addTarget(self, action: #selector(datePickerValueChanded(_:)), for: .valueChanged)
  }
  
  @objc func datePickerValueChanded(_ sender: UIDatePicker){
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
  }

  
  func setUp(){}
  
}

extension CurrentBaseViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView
    ,layout collectionViewLayout: UICollectionViewLayout
    ,sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }
}

extension CurrentBaseViewController: UICollectionViewDelegate{
  
}
