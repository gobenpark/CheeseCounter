//
//  PageViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 30..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class SetUpPageViewController: UIPageViewController {
  
  var pageViewControllers: [UIViewController] = []
  weak var Delegate: SetUpPageViewControllerDelegate?
  var isdisableScroll = true
  
  override func viewDidLoad(){
    dataSource = self
    delegate = self
    if let initialViewController = pageViewControllers.first {
      scrollToViewController(initialViewController)
    }
    Delegate?.setUpPageViewController(self,didUpdatePageCount: pageViewControllers.count)
  }
  
  fileprivate func scrollToViewController(_ viewController: UIViewController,direction: UIPageViewControllerNavigationDirection = .forward) {
    setViewControllers([viewController],direction: direction,animated: true,completion: { (finished) -> Void in
      // Setting the view controller programmatically does not fire
      // any delegate methods, so we have to manually notify the
      // 'tutorialDelegate' of the new index.
      self.notifyDelegateOfNewIndex()
    })
  }
  
  fileprivate func notifyDelegateOfNewIndex() {
    if let firstViewController = viewControllers?.first,
      let index = pageViewControllers.index(of: firstViewController) {
      Delegate?.setUpPageViewController(self,didUpdatePageIndex: index)
    }
  }
  
  func scrollToViewController(index newIndex: Int) {
    if let firstViewController = viewControllers?.first,let currentIndex = pageViewControllers.index(of: firstViewController) {
      let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
      let nextViewController = pageViewControllers[newIndex]
      scrollToViewController(nextViewController, direction: direction)
    }
  }
}


extension SetUpPageViewController: UIPageViewControllerDelegate{
  func pageViewController(_ pageViewController: UIPageViewController,didFinishAnimating finished: Bool,previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    notifyDelegateOfNewIndex()
  }
}

extension SetUpPageViewController: UIPageViewControllerDataSource{
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = pageViewControllers.index(of: viewController) else {
      return nil
    }
    
    let nextIndex = viewControllerIndex + 1
    let pageViewControllersCount = pageViewControllers.count
    
    guard pageViewControllersCount > nextIndex else {
      return nil
    }
    
    return pageViewControllers[nextIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = pageViewControllers.index(of: viewController) else {
      return nil
    }
    
    let previousIndex = viewControllerIndex - 1
    guard previousIndex >= 0 else {
      return nil
    }
    
    guard pageViewControllers.count > previousIndex else {
      return nil
    }
    
    return pageViewControllers[previousIndex]
  }
  
}

protocol SetUpPageViewControllerDelegate: class {
  
  /**
   Called when the number of pages is updated.
   
   - parameter tutorialPageViewController: the TutorialPageViewController instance
   - parameter count: the total number of pages.
   */
  func setUpPageViewController(_ PageViewController: SetUpPageViewController,didUpdatePageCount count: Int)
  
  /**
   Called when the current index is updated.
   
   - parameter tutorialPageViewController: the TutorialPageViewController instance
   - parameter index: the index of the currently visible page.
   */
  func setUpPageViewController(_ PageViewController: SetUpPageViewController,didUpdatePageIndex index: Int)
  
}


