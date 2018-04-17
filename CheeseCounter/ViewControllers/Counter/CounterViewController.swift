//
//  NewCounterViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 19..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import XLPagerTabStrip

class CounterViewController: ButtonBarPagerTabStripViewController{

  private var timer: Disposable? = nil
  let disposeBag = DisposeBag()
  let winViewController = WinViewController()
  
  let myPageButton: UIBarButtonItem = {
    let button = UIBarButtonItem()
    button.image = #imageLiteral(resourceName: "btnMypage").withRenderingMode(.alwaysOriginal)
    button.style = .plain
    return button
  }()
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    title = "카운터"
    self.navigationItem.setRightBarButtonItems([myPageButton], animated: true)
    settings.style.buttonBarItemTitleColor = .black
    settings.style.selectedBarBackgroundColor = .white
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.buttonBarItemFont = UIFont.CheeseFontMedium(size: 13.8)
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.selectedBarHeight = 1.5
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(winViewController.winnerView)
    winViewController.winnerView.snp.makeConstraints{ (make) in
      make.right.left.equalToSuperview()
      make.top.equalTo(self.buttonBarView.snp.bottom)
      make.height.equalTo(50)
    }
    
    winViewController.initView()
    
    self.navigationController?.navigationBar.setBottomBorderColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), height: 1)
    self.view.backgroundColor = .white
    self.buttonBarView.selectedBar.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.8588235294, blue: 0.1019607843, alpha: 1)
    self.buttonBarView.backgroundColor = .white
    
    myPageButton.rx.tap
      .map {return MypageNaviViewController()}
      .subscribe(onNext: { [weak self](vc) in
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
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    timer = Observable<Int>.timer(0, period: 30, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        guard let `self` = self else { return }
        self.winViewController.requestWinList()
//        log.info("requestWinList")
      }, onError: {(err) in log.error(err)})
//      .disposed(by: disposeBag)
    
    winViewController.winnerView.startAutoScroll()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    timer?.dispose()
    timer = nil
    winViewController.winnerView.stopAutoScroll()
  }
  
  override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    return [GameSelectViewController(),ShopViewController()]
  }
}

