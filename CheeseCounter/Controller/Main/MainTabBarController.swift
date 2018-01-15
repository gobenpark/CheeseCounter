//
//  MainTabBarController.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 3. 4..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import FirebaseMessaging

#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif

let globalTabEvent = PublishSubject<Int>()

class MainTabBarController: UITabBarController
{
  
  let cheeseViewController: UINavigationController = {
    let cv = CheeseViewController()
    let nvc = UINavigationController(rootViewController: cv)
    nvc.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 0.9978943467, green: 0.8484466672, blue: 0.1216805503, alpha: 1), height: 2)
    let tabBar = UITabBarItem(title: "응답", image: #imageLiteral(resourceName: "toolbar_answer@1x").withRenderingMode(.alwaysTemplate), tag: 0)
    let cheeseColor: UIColor = UIColor(gradientStyle: .leftToRight
      , withFrame: CGRect(x: 0, y: 0, width: 50, height: 50), andColors: [#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 1, green: 0.848323524, blue: 0.005472274031, alpha: 1)])
//    tabBar.imageInsets = UIEdgeInsets(top: -5, left: 0, bottom: 5, right: 0)
    tabBar.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 11),NSAttributedStringKey.foregroundColor:UIColor.black], for: .normal)
    cv.tabBarItem = tabBar
    return nvc
  }()
  
  let listViewController: UINavigationController = {
    let vc = UINavigationController(rootViewController: ListViewController())
    vc.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), height: 1)
    let tabBar = UITabBarItem(title: "리스트", image: #imageLiteral(resourceName: "toolbar_list@1x"), tag: 1)
//    tabBar.imageInsets = UIEdgeInsets(top: -5, left: 0, bottom: 5, right: 0)
    tabBar.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 11)
      ,NSAttributedStringKey.foregroundColor:UIColor.black]
      , for: .normal)
    vc.tabBarItem = tabBar
    return vc
  }()
  
  let questionViewController: UINavigationController = {
    let vc = UINavigationController(rootViewController: QuestionTableViewController())
    vc.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 0.9978943467, green: 0.8484466672, blue: 0.1216805503, alpha: 1), height: 2)
    let tabBar = UITabBarItem(title: "질문", image: #imageLiteral(resourceName: "toolbar_question@1x"), tag: 2)
//    tabBar.imageInsets = UIEdgeInsets(top: -5, left: 0, bottom: 5, right: 0)
    tabBar.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 11)
      ,NSAttributedStringKey.foregroundColor:UIColor.black], for: .normal)
    vc.tabBarItem = tabBar
    return vc
  }()
  
  let alertViewController: UINavigationController = {
    let vc = UINavigationController(rootViewController: AlertViewController())
    let tabBar = UITabBarItem(title: "알림", image: #imageLiteral(resourceName: "toolbar_alarm@1x"), tag: 3)
    vc.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 0.9978943467, green: 0.8484466672, blue: 0.1216805503, alpha: 1), height: 2)
//    tabBar.imageInsets = UIEdgeInsets(top: -5, left: 0, bottom: 5, right: 0)
    tabBar.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 11)
      ,NSAttributedStringKey.foregroundColor:UIColor.black]
      , for: .normal)
    vc.tabBarItem = tabBar
    return vc
  }()
  
  let counterViewController: UINavigationController = {
    let vc = UINavigationController(rootViewController: CounterViewController())
    _ = vc.topViewController?.view
    let tabBar = UITabBarItem(title: "카운터", image: #imageLiteral(resourceName: "toolbar_counter@1x"), tag: 4)
    tabBar.selectedImage = #imageLiteral(resourceName: "toolbar_counter_select@1x")
//    tabBar.imageInsets = UIEdgeInsets(top: -5, left: 0, bottom: 5, right: 0)
    tabBar.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.CheeseFontMedium(size: 11)
      ,NSAttributedStringKey.foregroundColor:UIColor.black]
      , for: .normal)
    vc.tabBarItem = tabBar
    return vc
  }()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewControllers = [cheeseViewController,
                       listViewController,
                       questionViewController,
                       alertViewController,
                       counterViewController]
    
    self.selectedIndex = 0
    self.tabBar.backgroundColor = .white
    if #available(iOS 10.0, *) {
      self.tabBar.unselectedItemTintColor = .black
    } else {
      self.tabBar.items?.forEach({ (tabBar) in
        tabBar.image = tabBar.image?.withRenderingMode(.alwaysOriginal)
        tabBar.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.blue], for: .normal)
      })
    }
    
    self.tabBar.items?.forEach({ (tabBar) in
      tabBar.image = tabBar.image?.withRenderingMode(.alwaysOriginal)
    })
    
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
    
    if item.tag == 1{
      if let listView = listViewController.topViewController as? ListViewController{
        listView.fetchChildViewControllers()
      }
    }
  }
}



