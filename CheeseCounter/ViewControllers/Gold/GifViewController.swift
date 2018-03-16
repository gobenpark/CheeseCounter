//
//  SampleViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 6. 2..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit
import YLGIFImage
import Lottie

enum gifType{
  case gold
  case cheese
}

class GifViewController: UIViewController{
  
  var dismissCompleteAction:(() -> Void)?
  
  var imageType: gifType = .gold{
    didSet{
      if imageType == .gold{
        imgView = LOTAnimationView(name: "cheese_reward")
        imgView.animationSpeed = 0.9
      }else if imageType == .cheese {
        imgView = LOTAnimationView(name: "cheese_reward")
        imgView.animationSpeed = 0.9
      }
    }
  }
  
  var imgView: LOTAnimationView = LOTAnimationView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(imgView)
    self.view.backgroundColor = .clear
    
    imgView.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
      make.height.equalTo(imgView.snp.width)
      make.width.equalToSuperview().dividedBy(1.5)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    imgView.play { (isplay) in
      self.dismissAction()
    }
  }
  
  func dismissAction(){
    self.presentingViewController?.dismiss(animated: true){[weak self] in
      guard let tap = self?.dismissCompleteAction else {return}
      tap()
    }
  }
}
