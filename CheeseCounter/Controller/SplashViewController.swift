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

class SplashViewController: UIViewController {
  
  
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
    let startTime = CFAbsoluteTimeGetCurrent()
    log.info("스플레시 스타트:\(startTime)")
    UserService.me() {[weak self] response in
      switch response.result {
      case .success(let value):
        if let enabled = value.data?.isEnable {
          switch enabled {
          case "0":
            AppDelegate.instance?.window?.rootViewController = UserSetupViewController()
            NotificationCenter.default.post(name: NSNotification.Name("splashEnd"), object: ["isEnable":false])
          case "1":
            AppDelegate.instance?.window?.rootViewController = MainTabBarController()
            NotificationCenter.default.post(name: NSNotification.Name("splashEnd"), object: ["isEnable":true])
          default:
            self?.activityView.stopAnimating()
            break
          }
          
          log.info("스플레시뷰 끝: \(CFAbsoluteTimeGetCurrent()-startTime)")
        }
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
  }
}



