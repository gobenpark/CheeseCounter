//
//  KnowHowView.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 23..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class QuestionKnowHowViewController: UIViewController {
  
  let imgView: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "7-4-1_question_coach_mark"))
    img.isUserInteractionEnabled = true
    return img
  }()
  
  lazy var dismissButton: UIButton = {
    let button = UIButton()
    button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view = imgView
    
    self.view.addSubview(dismissButton)
    
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
}
