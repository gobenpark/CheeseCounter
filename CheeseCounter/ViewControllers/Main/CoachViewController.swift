//
//  CoachCollectionViewCollectionViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 5. 17..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class CoachViewController: UIViewController {
  
  var didTap:(()->Void)?
  
  lazy var dismissButton: UIButton = {
    let button = UIButton()
    button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
    return button
  }()
  
  let images: [UIImage] = [#imageLiteral(resourceName: "5-1_answer_coach_mark"),#imageLiteral(resourceName: "coach_mark_list"),#imageLiteral(resourceName: "coach_mark_question")
    ,#imageLiteral(resourceName: "7-4-1_question_coach_mark"),#imageLiteral(resourceName: "8_alarm_coach_mark"),#imageLiteral(resourceName: "coach_mark_counter")]
  
  let imgView: UIImageView = {
    let img = UIImageView()
    img.isUserInteractionEnabled = true 
    return img
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view = imgView
    self.view.addSubview(dismissButton)
    self.modalPresentationStyle = .popover
    
    dismissButton.snp.makeConstraints{ (make) in
      make.top.equalToSuperview().inset(10)
      make.right.equalToSuperview().inset(10)
      make.height.equalTo(50)
      make.width.equalTo(50)
    }
  }
  
  @objc func dismissAction(){
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
