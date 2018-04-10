//
//  MainTabBarController.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 3. 4..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import FirebaseMessaging
import SwiftyUserDefaults

#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif

let globalTabEvent = PublishSubject<Int>()

class MainTabBarController: UITabBarController
{
  let disposeBag = DisposeBag()
  let cheeseViewController: UINavigationController = {
    let cv = CheeseTabViewController()
    let nvc = UINavigationController(rootViewController: cv)
    let tabBar = UITabBarItem(title: "응답", image: #imageLiteral(resourceName: "btnAnswer"), tag: 0)
    tabBar.selectedImage = #imageLiteral(resourceName: "btnAnswerP").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    let cheeseColor: UIColor = UIColor(gradientStyle: .leftToRight
      , withFrame: CGRect(x: 0, y: 0, width: 50, height: 50), andColors: [#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 1, green: 0.848323524, blue: 0.005472274031, alpha: 1)])
    tabBar.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 11),NSAttributedStringKey.foregroundColor:UIColor.black], for: .normal)
    
    cv.tabBarItem = tabBar
    return nvc
  }()
  
  let listViewController: UINavigationController = {
    let vc = UINavigationController(rootViewController: ListViewController())
//    vc.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), height: 1)
    vc.navigationBar.shadowImage = UIImage()
    let tabBar = UITabBarItem(title: "리스트", image: #imageLiteral(resourceName: "btnList"), tag: 1)
    tabBar.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 11)
      ,NSAttributedStringKey.foregroundColor:UIColor.black]
      , for: .normal)
    tabBar.selectedImage = #imageLiteral(resourceName: "btnListP").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    vc.tabBarItem = tabBar
    return vc
  }()
  
  let questionNavViewController: UINavigationController = {
    let vc = UINavigationController(rootViewController: QuestionViewController())
    vc.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 0.9978943467, green: 0.8484466672, blue: 0.1216805503, alpha: 1), height: 2)
    let tabBar = UITabBarItem(title: "질문", image: #imageLiteral(resourceName: "btnQuestion"), tag: 2)
    tabBar.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 11)
      ,NSAttributedStringKey.foregroundColor:UIColor.black], for: .normal)
    tabBar.selectedImage = #imageLiteral(resourceName: "btnQuestionP").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    vc.tabBarItem = tabBar
    return vc
  }()
  
  let alertViewController: UINavigationController = {
    let vc = UINavigationController(rootViewController: AlertViewController())
    let tabBar = UITabBarItem(title: "알림", image: #imageLiteral(resourceName: "btnAlarm"), tag: 3)
    vc.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 0.9978943467, green: 0.8484466672, blue: 0.1216805503, alpha: 1), height: 2)
    tabBar.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 11)
      ,NSAttributedStringKey.foregroundColor:UIColor.black]
      , for: .normal)
    tabBar.selectedImage = #imageLiteral(resourceName: "btnAlarmP").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    vc.tabBarItem = tabBar
    return vc
  }()
  
  let counterViewController: UINavigationController = {
    
    let vc = UINavigationController(rootViewController: CounterViewController())
    _ = vc.topViewController?.view
    let tabBar = UITabBarItem(title: "카운터", image: #imageLiteral(resourceName: "btnCounter"), tag: 4)
//    tabBar.selectedImage = #imageLiteral(resourceName: "toolbar_counter_select@1x")
    tabBar.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 11)
      ,NSAttributedStringKey.foregroundColor:UIColor.black]
      , for: .normal)
    tabBar.selectedImage = #imageLiteral(resourceName: "btnCounterP").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    vc.tabBarItem = tabBar
    return vc
  }()

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    CheeseService.provider
      .request(.getTodayEventList)
      .filter(statusCode: 200)
      .map(EventModel.self)
      .asObservable()
      .filter{$0.result.data.count > 0}
      .bind(onNext: popUpEvent)
      .disposed(by: disposeBag)
  }
  
  private func popUpEvent(models: EventModel){
    
    var idx: Int = -1
    for i in 0..<models.result.data.count{
      if !Defaults[.popUpIDs].contains(models.result.data[i].id){
        idx = i
        break
      }
    }
    guard idx != -1 else {return}
    
    let vc = EventViewController(model: models.result.data[idx])
    vc.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2960455908)
    for i in idx..<models.result.data.count - 1{
      searchChildVC(vc: vc, model: models.result.data[i+1])
    }
    AppDelegate.instance?.window?.rootViewController?.present(vc, animated: true, completion: nil)
  }
  
  private func searchChildVC(vc: EventViewController, model: EventModel.Data){
    guard !Defaults[.popUpIDs].contains(model.id) else {return}
    
    if vc.childVC == nil {
      vc.childVC = EventViewController(model: model)
    }else{
      searchChildVC(vc: vc.childVC!, model: model)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewControllers = [cheeseViewController,
                       listViewController,
                       questionNavViewController,
                       alertViewController,
                       counterViewController]
    
    self.selectedIndex = 0
    self.tabBar.backgroundColor = .white
    if #available(iOS 10.0, *) {
      self.tabBar.unselectedItemTintColor = .black
    } else {
      self.tabBar.items?.forEach({ (tabBar) in
        tabBar.image = tabBar.image?.withRenderingMode(.alwaysOriginal)
      })
    }
    
    let message = Messaging.messaging()
    message.subscribe(toTopic: "notice")
    message.subscribe(toTopic: "update")
    message.subscribe(toTopic: "event")
  }
  

  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
  }
  
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    globalTabEvent.onNext(item.tag)
  }
}

func ==(lhs: [String], rhs: [EventModel.Data]) -> Bool{
  var result = false
  for lh in lhs{
    for rh in rhs{
      return lh == rh.id
    }
  }
  return false
}

func ==(lhs:[String], rhs: String) -> Bool{
  for lh in lhs{
    if lh == rhs{
      return true
    }
  }
  return false
}


