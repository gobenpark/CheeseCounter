//
//  MyPageViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 2..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import XLPagerTabStrip
import Moya
import Toaster

final class MypageNaviViewController: UINavigationController{
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
  }
  
  init() {
    super.init(rootViewController: MyPageViewController())
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class MyPageViewController: UIViewController{
  
  let containerVC = MyPageContainerViewController()
  let disposeBag = DisposeBag()
  let provider = MoyaProvider<CheeseCounter>().rx
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "마이페이지"
    label.font = UIFont.CheeseFontMedium(size: 18)
    return label
  }()
  
  let dismissButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "btnClose"), for: .normal)
    return button
  }()
  
  let headerView = CounterHeaderView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    title = "마이페이지"
    self.view.addSubview(headerView)
    self.addChildViewController(containerVC)
    self.view.addSubview(containerVC.view)
    self.view.addSubview(titleLabel)
    self.view.addSubview(dismissButton)
    
    ToastView.appearance().font = UIFont.CheeseFontMedium(size: 15)
    ToastView.appearance().bottomOffsetPortrait = 100
    
    provider.request(.getMyInfo)
      .filter(statusCode: 200)
      .map(UserInfoModel.self)
      .asObservable()
      .bind(onNext: headerView.mapper)
      .disposed(by: disposeBag)
    
    dismissButton.rx.tap
      .subscribe {[weak self] (_) in
        self?.dismiss(animated: true, completion: nil)}
      .disposed(by: disposeBag)
    
    headerView.configureButton.rx.tap
      .map{_ in return ConfigViewController()}
      .subscribe(onNext: {[weak self] (vc) in
        self?.navigationController?.pushViewController(vc, animated: true)
      }).disposed(by: disposeBag)
    
    headerView.copyButton.rx.tap
      .subscribe(onNext: { _ in 
        UIPasteboard.general.string = UserData.instance.userID.components(separatedBy: "_")[1]
        Toast(text: "복사되었습니다.", delay: 0.1, duration: 0.5).show()
      })
      .disposed(by: disposeBag)
    
    addConstraint()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.navigationBar.isHidden = false
  }
  
  private func addConstraint(){
    
    titleLabel.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(50)
    }
    
    dismissButton.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(12)
      make.top.equalToSuperview().inset(50)
      make.height.equalTo(20)
      make.width.equalTo(20)
    }
    
    headerView.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(24)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(80)
    }
    
    containerVC.view.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
      make.top.equalTo(headerView.snp.bottom)
    }
  }
}


final class MyPageContainerViewController: ButtonBarPagerTabStripViewController{
  
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    
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
    self.buttonBarView.selectedBar.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.8588235294, blue: 0.1019607843, alpha: 1)
    self.buttonBarView.backgroundColor = .white
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
  
  override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    return [RankViewController(),HistoryViewController(),CouponHistoryViewController()]
  }
}
