////
////  LevelUpViewController.swift
////  CheeseCounter
////
////  Created by xiilab on 2018. 5. 15..
////  Copyright © 2018년 xiilab. All rights reserved.
////
//
//import UIKit
//
//class LevelUpViewController: UIViewController {
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    let view = MessageView.viewFromNib(layout: .centeredView)
//    
//    view.titleLabel?.text = "축하합니다!\n새로운 프로필을 얻었습니다."
//    view.button?.setTitle("나중에 하기", for: .normal)
//    view.button?.setTitleColor(.gray, for: .normal)
//    
//    view.iconImageView?.image = #imageLiteral(resourceName: "imgLevelUpPopup")
//    
//    var config = SwiftMessages.Config()
//    config.presentationStyle = .center
//    config.duration = .forever
//    config.dimMode = .gray(interactive: false)
//    config.interactiveHide = false
//    
//    SwiftMessages.show(config: config, view: view)
//  }
//  
//  override func didReceiveMemoryWarning() {
//    super.didReceiveMemoryWarning()
//    
//  }
//}
