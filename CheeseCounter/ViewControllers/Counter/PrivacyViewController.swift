//
//  UsingServiceClauseVC.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 27..
//  Copyright © 2017년 xiilab. All rights reserved.
//  약관페이지 

import UIKit
import WebKit
import XLPagerTabStrip

final class PrivacyViewController: ButtonBarPagerTabStripViewController{
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    
    settings.style.buttonBarItemTitleColor = .black
    settings.style.selectedBarBackgroundColor = .white
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.buttonBarItemFont = UIFont.CheeseFontMedium(size: 13.8)
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.selectedBarHeight = 1.5
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
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    return [UsingServiceClauseVC(),UsingPrivacyVC()]
  }
}

class UsingServiceClauseVC: UIViewController, IndicatorInfoProvider{
  
  lazy var webView: WKWebView = {
    let url = UserService.url+"/m/terms"
    let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    webView.load(URLRequest(url: URL(string: url)!))
    return webView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(webView)
    
    webView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "서비스 이용약관")
  }
}

class UsingPrivacyVC: UIViewController, IndicatorInfoProvider{
  
  lazy var webView: WKWebView = {
    let url = UserService.url+"/m/privacy"
    let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    webView.load(URLRequest(url: URL(string: url)!))
    return webView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(webView)
    
    webView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "개인정보 취급방침")
  }
}

