//
//  CheesePageViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 4. 9..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import XLPagerTabStrip
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

class CheesePageViewController: ButtonBarPagerTabStripViewController{
  
  let disposeBag = DisposeBag()

  var bottomView: UIView?
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
  
  override func loadView() {
    super.loadView()
    title = "응답"
    self.view.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
    self.navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBarSetup()
    
    myPageButton.rx.tap
      .map{ _ in return MypageNaviViewController()}
      .subscribe(onNext: { [weak self] (vc) in
        self?.present(vc, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    searchButton
      .rx
      .tap.subscribe {[weak self] (_) in
        self?.navigationController?.pushViewController(CheeseViewController(isSearch: true), animated: false)
      }.disposed(by: disposeBag)
    
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
  
  private func navigationBarSetup(){
    self.navigationItem.setRightBarButtonItems([myPageButton,searchButton], animated: true)
    self.buttonBarView.selectedBar.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.8588235294, blue: 0.1019607843, alpha: 1)
    self.buttonBarView.backgroundColor = .white
  }
  
  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    return [CheeseViewController(),CheeseFilterViewController()]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
