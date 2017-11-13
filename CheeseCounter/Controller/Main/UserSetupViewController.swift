//
//  UserSetupViewController2.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 30..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import SnapKit
import Crashlytics

class UserSetupViewController: UIViewController {
  
  var isdisableScroll: Bool = true
  var signUp: SignUp = SignUp()
  
  lazy var viewControllers: [UIViewController] = {
    var VCS: [UIViewController] = []
    let view1 = ProvisionViewController()
    let view2 = NickNameViewController()
    let view3 = SelectGenderViewController()
    let view4 = SelectAgeViewController()
    let view5 = SelectAreaViewController()
    let view6 = CompleteJoinViewController()
    view1.userSetupViewController = self
    view2.userSetupViewController = self
    view3.userSetupViewController = self
    view4.userSetupViewController = self
    view5.userSetupViewController = self
    view6.userSetupViewController = self
    VCS.append(view1)
    VCS.append(view2)
    VCS.append(view3)
    VCS.append(view4)
    VCS.append(view5)
    VCS.append(view6)
    return VCS
  }()
  
  lazy var pageControl: UIPageControl = {
    let pc = UIPageControl()
    pc.pageIndicatorTintColor = .lightGray
    pc.currentPageIndicatorTintColor = UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1)
    pc.isUserInteractionEnabled = false
    pc.numberOfPages = self.viewControllers.count
    return pc
  }()
  
  lazy var setUpPageViewController: SetUpPageViewController = {
    let setUpPageViewController = SetUpPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    setUpPageViewController.pageViewControllers = self.viewControllers
    setUpPageViewController.Delegate = self
    return setUpPageViewController
  }()
  
  var bottomLayout: Constraint?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.addChildViewController(setUpPageViewController)
    self.view.addSubview(setUpPageViewController.view)
    self.view.addSubview(pageControl)
    self.view.backgroundColor = .white
    
    setUpPageViewController.view.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    pageControl.snp.makeConstraints { [weak self] (make) in
      guard let `self` = self else {return}
      self.bottomLayout = make.bottom.equalToSuperview().inset(-60).constraint
      make.centerX.equalToSuperview()
    }
    
    pageControl.addTarget(self, action: #selector(UserSetupViewController.didChangePageControlValue), for: .valueChanged)
    
  }
  
  @objc func didChangePageControlValue() {
    setUpPageViewController.scrollToViewController(index: pageControl.currentPage)
  }
  
  func uploadUserInfo(){
    
    UserService.register(parameter: signUp.getParameters()) { (response) in
      let cheeseVC = WelcomeCoachViewController()
      cheeseVC.modalPresentationStyle = .popover
      cheeseVC.didTap = {
        AppDelegate.instance?.reloadRootViewController()
      }
      switch response.result {
      case .success(let value):
        if value.data?.isEnable == "1" {
          Answers.logSignUp(withMethod: "SignUp!", success: true, customAttributes: self.signUp.getParameters())
          self.present(cheeseVC, animated: true, completion: nil)
        }
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
  }
}

extension UserSetupViewController: SetUpPageViewControllerDelegate{
  
  func setUpPageViewController(_ PageViewController: SetUpPageViewController,didUpdatePageCount count: Int){
    self.pageControl.numberOfPages = count
  }
  
  func setUpPageViewController(_ PageViewController: SetUpPageViewController,didUpdatePageIndex index: Int){
    if index >= 1 && index != 5{
      UIView.animate(withDuration: 0.5, animations: {
        self.bottomLayout?.update(offset: -60)
      })
    } else {
      UIView.animate(withDuration: 0.5, animations: {
        self.bottomLayout?.update(offset: 50)
      })
    }
    self.pageControl.currentPage = index
  }
}



