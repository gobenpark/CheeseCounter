//
//  ListViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 6..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import AAFragmentManager
import BetterSegmentedControl
#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif


protocol listViewControllerDelegate {
  func pushViewController(cheeseData:CheeseResult)
}

class ListViewController: UIViewController , listViewControllerDelegate
{
  
  var segmentViewHeight: CGFloat?
  
  var childView: AAFragmentManager = {
    let fragmanager = AAFragmentManager()
    fragmanager.allowSameFragment = true
    return fragmanager
  }()
  
  let extendedNavBarView = ExtendedNavBarView()
  
  let listQuestionViewController = ListQuestionViewController()
  let listAnswerTableViewController = ListAnswerTableViewController()
  let sympathyTableViewController = SympathyTableViewController()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationBarSetup()
    
    view.backgroundColor = .white
    view.addSubview(extendedNavBarView)
    view.addSubview(childView)
    
//    self.definesPresentationContext = true
    
    extendedNavBarView.segmentedControl.addTarget(self, action: #selector(segmentControlEvent(_:)), for: .valueChanged)
    extendedNavBarView.setBottomBorderColor(color: #colorLiteral(red: 0.9978943467, green: 0.8484466672, blue: 0.1216805503, alpha: 1), height: 2)
    
    childView.setupFragments([listQuestionViewController,listAnswerTableViewController,sympathyTableViewController], defaultIndex: 0)
    
    segmentViewHeight = (self.navigationController?.navigationBar.frame.height ?? 0) + UIApplication.shared.statusBarFrame.height
    
    listQuestionViewController.delegate = self
    listAnswerTableViewController.delegate = self
    sympathyTableViewController.delegate = self
    
    extendedNavBarView.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(80)
    }
    
    childView.snp.makeConstraints { (make) in
      make.top.equalTo(extendedNavBarView.snp.bottom)
      make.left.equalTo(view)
      make.right.equalTo(view)
      make.bottom.equalTo(view)
    }
    
    self.automaticallyAdjustsScrollViewInsets = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.setBottomBorderColor(color: .white, height: 2)
  }
  
  func navigationBarSetup(){
    
    let titleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 140, height: 30))
    titleButton.setTitle("리스트", for: .normal)
    titleButton.setImage(#imageLiteral(resourceName: "icon_gold@1x"), for: .normal)
    titleButton.addTarget(self, action: #selector(presentCoachView), for: .touchUpInside)
    titleButton.titleLabel?.font = UIFont.CheeseFontBold(size: 17)
    titleButton.semanticContentAttribute = .forceRightToLeft
    titleButton.imageEdgeInsets = UIEdgeInsets(top: 2.5, left: 10, bottom: 0, right: 0)
    titleButton.setTitleColor(.black, for: .normal)
    self.navigationItem.titleView = titleButton
  }
  
  
  func presentCoachView(){
    let coachView = CoachViewController()
    coachView.imgView.image = coachView.images[1]
    self.present(coachView, animated: true, completion: nil)
  }
  
  func fetchChildViewControllers(){
    listQuestionViewController.fetch(paging: .refresh)
    listAnswerTableViewController.fetch(paging: .refresh)
    sympathyTableViewController.fetch(paging: .refresh)
  }
  
  
  func segmentControlEvent(_ segmentControl: BetterSegmentedControl){
    let index = Int(segmentControl.index)
    childView.replaceFragment(withIndex: index)
  }
  
  func pushViewController(cheeseData: CheeseResult){
    let cheeseResultViewController = CheeseResultViewController()
    cheeseResultViewController.cheeseData = cheeseData.cheeseData
    self.navigationController?.pushViewController(cheeseResultViewController, animated: true)
  }
}

