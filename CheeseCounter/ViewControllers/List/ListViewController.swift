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
import XLPagerTabStrip

#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif


protocol listViewControllerDelegate {
  func pushViewController(cheeseData:CheeseResult)
}

class ListViewController: ButtonBarPagerTabStripViewController{
  
  let disposeBag = DisposeBag()
  
  let myPageButton: UIBarButtonItem = {
    let button = UIBarButtonItem()
    button.image = #imageLiteral(resourceName: "btnMypage").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    button.style = .plain
    return button
  }()
  
  let searchButton: UIBarButtonItem = {
    let barbutton = UIBarButtonItem()
    barbutton.image = #imageLiteral(resourceName: "header_search@1x").withRenderingMode(.alwaysTemplate)
    barbutton.style = .plain
    barbutton.tintColor = .black
    return barbutton
  }()

  
//  let searchButton = UIBarButtonItem()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationBarSetup()
    
    myPageButton.rx.tap
      .map {return MyPageViewController()}
      .subscribe(onNext: { [weak self](vc) in
        vc.modalPresentationStyle = .overCurrentContext
        self?.present(vc, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    changeCurrentIndexProgressive = {
      (oldCell: ButtonBarViewCell?
      , newCell: ButtonBarViewCell?
      , progressPercentage: CGFloat
      , changeCurrentIndex: Bool
      , animated: Bool) -> Void in
      
      guard changeCurrentIndex == true else { return }
      oldCell?.label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
      newCell?.label.textColor = .black
    }
    
    
    self.automaticallyAdjustsScrollViewInsets = false
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    
    settings.style.buttonBarItemTitleColor = .black
    settings.style.selectedBarBackgroundColor = .white
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.buttonBarItemFont = UIFont.CheeseFontMedium(size: 13.8)
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.selectedBarHeight = 1.5
  }
  
  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    return [QuestionViewController(),AnswerViewController(),SympathyViewController(),ReplyListViewController()]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func addConstraint(){
    
  }
  
  @objc private dynamic func searchViewPresent(){
    let searchView = UINavigationController(rootViewController: SearchListViewController(type: .list))
    searchView.modalPresentationStyle = .overCurrentContext
    AppDelegate.instance?.window?.rootViewController?.present(searchView, animated: false, completion: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.setBottomBorderColor(color: .white, height: 2)
  }
  
  private func navigationBarSetup(){
    
    let titleLabel = UILabel()
    titleLabel.text = "리스트"
    titleLabel.font = UIFont.CheeseFontBold(size: 18)
    titleLabel.sizeToFit()
    self.navigationItem.titleView = titleLabel
    self.navigationItem.setRightBarButtonItems([searchButton,searchButton], animated: true)
    self.buttonBarView.selectedBar.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.8588235294, blue: 0.1019607843, alpha: 1)
    self.buttonBarView.backgroundColor = .white
  }
  
  
  @objc func presentCoachView(){
    let coachView = CoachViewController()
    coachView.imgView.image = coachView.images[1]
    self.present(coachView, animated: true, completion: nil)
  }
  
  func fetchChildViewControllers(){
//    listQuestionViewController.fetch(paging: .refresh)
//    listAnswerTableViewController.fetch(paging: .refresh)
//    sympathyTableViewController.fetch(paging: .refresh)
  }
  
  
  func pushViewController(cheeseData: CheeseResult){
//    let cheeseResultViewController = CheeseResultViewController()
//    cheeseResultViewController.cheeseData = cheeseData.cheeseData
//    self.navigationController?.pushViewController(cheeseResultViewController, animated: true)
  }
}


