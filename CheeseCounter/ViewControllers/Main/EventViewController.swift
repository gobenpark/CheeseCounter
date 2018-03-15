//
//  File.swift
//  CheeseCounter
//
//  Created by park bumwoo on 2018. 3. 1..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class EventViewController: UIViewController{
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
  let detailButton: UIButton = {
    let button = UIButton()
    button.setTitle("자세히보기", for: .normal)
    return button
  }()
  
  let cancelButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "btnClose"), for: .normal)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(imageView)
    view.addSubview(detailButton)
    view.addSubview(cancelButton)
    addConstraint()
  }
  
  private func addConstraint(){
    
  }
}
