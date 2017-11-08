//
//  KakaoLoginController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 8. 1..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class KakaoLoginController: UIViewController{
  
  lazy var kakaoLoginButton : UIButton = {
    let button = UIButton()
    let attribute = NSAttributedString(string: "카카오톡으로 로그인",
                                       attributes: [NSForegroundColorAttributeName : UIColor.rgb(red: 255, green: 135, blue: 0),
                                                    NSFontAttributeName:UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium)])
    button.backgroundColor = .white
    button.setAttributedTitle(attribute, for: .normal)
    button.addTarget(self, action: #selector(kakaoLogin), for: UIControlEvents.touchUpInside)
    return button
  }()
  
  let backgroundImageView: UIImageView = {
    let imgView = UIImageView(image: #imageLiteral(resourceName: "bg_intro@1x"))
    return imgView
  }()
  
  let logoImageView: UIImageView = {
    let img = UIImageView(image: #imageLiteral(resourceName: "intro_logo_kor@1x"))
    return img
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(backgroundImageView)
    view.addSubview(kakaoLoginButton)
    view.addSubview(logoImageView)
    addConstraint()
  }
  
  fileprivate func addConstraint(){
    
    backgroundImageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    logoImageView.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(136)
      make.centerX.equalToSuperview().inset(5)
      make.height.equalTo(200)
      make.width.equalTo(167)
    }
    
    kakaoLoginButton.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.right.equalToSuperview().inset(25)
      make.bottom.equalToSuperview().inset(40)
      make.height.equalTo(50)
    }
  }
  
  fileprivate dynamic func kakaoLogin(){
    
    let session:KOSession = KOSession.shared()
    
    if session.isOpen(){
      session.close()
    }
    
    
    
    session.open(completionHandler: { (error) in
      if !session.isOpen() {
        switch ((error as! NSError).code) {
        case Int(KOErrorCancelled.rawValue):
          break
        default:
          let alertController = UIAlertController(title: "에러", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
          let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
          alertController.addAction(defaultAction)
//          self.loginViewController?.present(alertController, animated: true , completion: nil)
          break
        }
      }
    }, authParams: nil, authTypes: nil)
  }
  
  
}
