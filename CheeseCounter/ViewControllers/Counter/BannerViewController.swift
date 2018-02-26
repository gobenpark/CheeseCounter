//
//  BannerViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 23..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit

class BannerViewController: UIPageViewController{
  
  var pages: [UIViewController] = []{
    didSet{
      log.info(pages.count)
      dataSource = nil
      dataSource = self
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dataSource = self
    delegate = self
    self.view.backgroundColor = .white
    if let initialViewController = pages.first {
      scrollToViewController(initialViewController)
    }
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
      let index = pages.index(of: firstViewController) {
    }
  }
  
  func scrollToViewController(index newIndex: Int) {
    if let firstViewController = viewControllers?.first,let currentIndex = pages.index(of: firstViewController) {
      let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
      let nextViewController = pages[newIndex]
      scrollToViewController(nextViewController, direction: direction)
    }
  }
}

extension BannerViewController: UIPageViewControllerDelegate{
  func pageViewController(_ pageViewController: UIPageViewController,didFinishAnimating finished: Bool,previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    notifyDelegateOfNewIndex()
  }
}

//extension BannerViewController: UIPageViewControllerDataSource{
//  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//    guard let index = pages.index(of: viewController as! Banner) else {return nil}
//
//    let previousIndex = index - 1
//
//    guard previousIndex >= 0 else {return pages.last}
//    guard pages.count > previousIndex else {return nil}
//    return pages[previousIndex]
//  }
//
//  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//    guard let index = pages.index(of: viewController as! Banner) else {return nil}
//
//    let nextIndex = index + 1
//
//    guard nextIndex < pages.count else {return pages.first}
//    guard pages.count > nextIndex else {return nil}
//    return pages[nextIndex]
//  }
//}


extension BannerViewController: UIPageViewControllerDataSource{
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = pages.index(of: viewController) else {
      return nil
    }
    
    let nextIndex = viewControllerIndex + 1
    let pageViewControllersCount = pages.count
    
    guard pageViewControllersCount > nextIndex else {
      return nil
    }
    
    return pages[nextIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = pages.index(of: viewController) else {
      return nil
    }
    
    let previousIndex = viewControllerIndex - 1
    guard previousIndex >= 0 else {
      return nil
    }
    
    guard pages.count > previousIndex else {
      return nil
    }
    
    return pages[previousIndex]
  }
}

final class Banner: UIViewController{
  
  var model: WinListModel.Data?{
    didSet{
      self.imageView.kf.setImage(with: URL(string: (model?.img_url ?? String()).getUrlWithEncoding()))
      self.label.text = "\(model?.nickname ?? String())님 당첨을 축하드립니다."
    }
  }
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .blue
    return imageView
  }()
  
  let dateLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontRegular(size: 11)
    label.text = "테스트"
    return label
  }()
  
  let label: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontRegular(size: 11)
    label.text = "테스트"
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(imageView)
    view.addSubview(dateLabel)
    view.addSubview(label)
    addConstraint()
  }
  private func addConstraint(){
    imageView.snp.makeConstraints { (make) in
      make.left.equalTo(10)
      make.top.equalTo(9)
      make.bottom.equalTo(-9)
      make.width.equalTo(imageView.snp.height)
    }
    
    dateLabel.snp.makeConstraints { (make) in
      make.left.equalTo(imageView.snp.right).offset(7.5)
      make.centerY.equalTo(imageView)
    }
    
    label.snp.makeConstraints { (make) in
      make.left.equalTo(dateLabel.snp.right).offset(45)
      make.centerY.equalTo(dateLabel)
    }
  }
}
