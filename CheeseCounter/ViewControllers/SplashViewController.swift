//
//  SplashViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 20..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import Alamofire
import ObjectMapper
import NVActivityIndicatorView
import Crashlytics
import RxSwift
import RxCocoa
import SwiftyJSON

class SplashViewController: UIViewController {
  let disposeBag = DisposeBag()
  
  let activityView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    view.startAnimating()
    return view
  }()
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    view.backgroundColor = .white
    self.view.addSubview(activityView)
    activityView.snp.makeConstraints{
      $0.center.equalToSuperview()
    }
    self.viewLoadAction()
  }
  
  func viewLoadAction(){
    KOSessionTask.meTask {[weak self] (result, error) in
      guard let `self` = self else {return}
      guard let result = result , error == nil else {return}
      if let user = result as? KOUser{
        
        let id = user.id
        let profile = user.property(forKey: KOUserProfileImagePropertyKey) as? String
        CheeseService.provider.request(.loginUser(id: "\(id ?? 0)", fcm_token: String(), img_url: profile ?? String(), access_token: KOSession.shared().accessToken, version: "1.0.3i"))
          .filter(statusCode: 200)
          .mapJSON()
          .map{JSON($0)}
          .subscribe(onSuccess: { (json) in
            if json["result"]["code"].intValue == 200{
              if json["result"]["data"]["is_enable"].intValue == 0{
                AppDelegate.instance?.window?.rootViewController = UserSetupViewController()
                NotificationCenter.default.post(name: NSNotification.Name("splashEnd"), object: ["isEnable":false])
              }else if json["result"]["data"]["is_enable"].intValue == 1{
                AppDelegate.instance?.window?.rootViewController = MainTabBarController()
                NotificationCenter.default.post(name: NSNotification.Name("splashEnd"), object: ["isEnable":true])
              }
            }else{
              AlertView(title: "최신버전 업데이트를 위해 스토어로 이동합니다.").addChildAction(title: "확인", style: .default, handeler: { (action) in
                UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id1235147317")!, options: [:], completionHandler: nil)
              }).show()
            }
            self.activityView.stopAnimating()
          }, onError: { (error) in
            log.error(error)
          }).disposed(by: self.disposeBag)
      }
    }
  }
}




