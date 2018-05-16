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

class UserData{
  static let instance = UserData()
  var userID = String()
}

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
//    log.info(TARGET_IPHONE_SIMULATOR)
    if isJailBrokenDevice() == true {
      AlertView(title: "탈옥폰은 썩 물러가렴").addChildAction(title: "확인", style: .default, handeler: { (action) in
        exit(0)
      }).show()
    } else {
      self.viewLoadAction()
    }
  }
  
  func viewLoadAction(){
    KOSessionTask.meTask {[weak self] (result, error) in
      guard let `self` = self else {return}
      guard let result = result , error == nil else {return}
      if let user = result as? KOUser{
        
        let id = user.id
        let profile = user.property(forKey: KOUserProfileImagePropertyKey) as? String
        
        CheeseService.provider.request(.loginUser(id: "\(id ?? 0)", fcm_token: String(), img_url: profile ?? String(), access_token: KOSession.shared().accessToken, version: CheeseService.version))
          .filter(statusCode: 200)
          .mapJSON()
          .map{JSON($0)}
          .debug()
          .subscribe(onSuccess: { (json) in
            log.info(json)
            if json["result"]["code"].intValue == 200{
              if json["result"]["data"]["is_enable"].intValue == 0{
                AppDelegate.instance?.window?.rootViewController = UserSetupViewController()
                NotificationCenter.default.post(name: NSNotification.Name("splashEnd"), object: ["isEnable":false])
              }else if json["result"]["data"]["is_enable"].intValue == 1 {
                AppDelegate.instance?.window?.rootViewController = MainTabBarController()
                UserData.instance.userID = json["result"]["data"]["id"].stringValue
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
            log.error(error.localizedDescription)
          }).disposed(by: self.disposeBag)
      }
    }
  }
  
  func isJailBrokenDevice() -> Bool {
    if TARGET_IPHONE_SIMULATOR != 1 {
      if FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
        || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
        || FileManager.default.fileExists(atPath: "/bin/bash")
        || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
        || FileManager.default.fileExists(atPath: "/etc/apt")
        || FileManager.default.fileExists(atPath: "/private/var/lib/apt/")
        || UIApplication.shared.canOpenURL(URL(string: "cydia://package/com.example.package")!) {
        
        return true
      }
      let stringToWrite = "Jailbreak Test"
      
      do {
        try stringToWrite.write(toFile: "/private/JailbreakTest.txt", atomically: true, encoding: String.Encoding.utf8)
        return true
      } catch {
        return false
      }
    } else {
      return false
    }
  }
}




