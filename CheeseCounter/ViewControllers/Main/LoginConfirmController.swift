////
////  LoginConfirmController.swift
////  CheeseCounter
////
////  Created by xiilab on 2017. 6. 26..
////  Copyright © 2017년 xiilab. All rights reserved.
////
//
//class LoginConfirmController{
//  
//  private let dispatchGroup = DispatchGroup()
//  private(set) var cheeseData: CheeseResultByDate.Data?
//  private let surveyId: String!
//  private var naviVC: UINavigationController?
//  private var isSurveySelected: Bool = false
//  
//  init(surveyId: String) {
//    self.surveyId = surveyId
//  }
//
//  func openViewFromUrl(){
//    setCheeseData()
//    if !KOSession.shared().isOpen(){
//      dispatchGroup.notify(queue: DispatchQueue.main, execute: {
//        let cheeseVC = CheeseSelectedViewController()
//        cheeseVC.cheeseData = self.cheeseData
//        cheeseVC.openType = .url
//        cheeseVC.isLogin = false
//        let naviVC = UINavigationController(rootViewController: cheeseVC)
//        naviVC.modalPresentationStyle = .overCurrentContext
//        AppDelegate.instance?.window?.rootViewController?.present(naviVC, animated: true, completion: nil)
//      })
//    }else{
//      
//      //서버 로그인 되어있음
//      if UserService.isLogin{
//        dispatchGroup.notify(queue: DispatchQueue.main, execute: {[weak self] (_) in
//          guard let `self` = self else {return}
//          self.openURLView()
//        })
//      }else{
//        //로그인이 안되어있는 상황
//        // isenable이 0 이거나 login 루틴진행중
//        NotificationCenter.default.addObserver(self, selector: #selector(splashEndAction(_:)), name: NSNotification.Name(rawValue: "splashEnd"), object: nil)
//      }
//    }
//  }
//  
//  private dynamic func splashEndAction(_ notification: NSNotification){
//    
//    if let isEnable = notification.userInfo?["isEnable"] as? Bool{
//      log.info("isEnable:\(isEnable)")
//    }
//
//    if UserService.isLogin{
//      self.openURLView()
//    }
//  }
//  
//  private func openURLView(){
//    let cheeseVC = CheeseSelectedViewController()
//    cheeseVC.cheeseData = self.cheeseData
//    cheeseVC.isLogin = true
//    cheeseVC.openType = .url
//    self.naviVC = UINavigationController(rootViewController: cheeseVC)
//    self.naviVC?.modalPresentationStyle = .overCurrentContext
//    AppDelegate.instance?.window?.rootViewController?.present(self.naviVC!, animated: true, completion: nil)
//  }
//  
//  private dynamic func dismissAction(){
//    naviVC?.dismiss(animated: true, completion: nil)
//  }
//  
//  private func setCheeseData(){
//    dispatchGroup.enter()
//    CheeseService.getSurveyById(surveyId: self.surveyId, {[weak self] (response) in
//      guard let `self` = self else {
//        log.error("error")
//        return
//      }
//      switch response.result{
//      case .success(let value):
//        self.cheeseData = value.singleData
//        self.dispatchGroup.leave()
//      case .failure(let error):
//        log.error("URL Setting data: \(error.localizedDescription)")
//      }
//    })
//  }
//}
