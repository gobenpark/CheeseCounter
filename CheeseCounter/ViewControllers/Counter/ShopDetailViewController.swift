//
//  ShopDetailViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 26..
//  Copyright © 2018년 xiilab. All rights reserved.
//  치즈로 구매하기 상세페이지

import UIKit
import WebKit
import Kingfisher
import RxSwift
import RxCocoa
import Toaster
import Moya
import SwiftyJSON

class ShopDetailViewController: UIViewController{
  let disposeBag = DisposeBag()
  
  lazy var webView: WKWebView = {
    let preferences = WKPreferences()
    preferences.javaScriptEnabled = true
    let configuration = WKWebViewConfiguration()
    configuration.preferences = preferences
    let webView = WKWebView(frame: .zero, configuration: configuration)
    webView.scrollView.pinchGestureRecognizer?.isEnabled = false
    webView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
    return webView
  }()

  let model: GiftViewModel.Item?
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .white
    return imageView
  }()
  
  let cheeseIcon = UIImageView(image: #imageLiteral(resourceName: "icCheese"))
  let cheesePriceLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.CheeseFontMedium(size: 14)
    return label
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    return label
  }()
  
  let buyButton: UIButton = {
    let button = UIButton()
    button.setTitle("구매하기", for: .normal)
    button.backgroundColor = #colorLiteral(red: 1, green: 0.848323524, blue: 0.005472274031, alpha: 1)
    return button
  }()
  
  init(model: GiftViewModel.Item?) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIView.animate(withDuration: 1.5) { [weak self] in
      self?.tabBarController?.tabBar.isHidden = true
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    UIView.animate(withDuration: 1.5) { [weak self] in
      self?.tabBarController?.tabBar.isHidden = false
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(webView)
    view.addSubview(titleLabel)
    view.addSubview(imageView)
    view.addSubview(buyButton)
    imageView.addSubview(cheesePriceLabel)
    imageView.addSubview(cheeseIcon)
    
    buyButton.rx.tap
      .bind(onNext: buyAction)
      .disposed(by: disposeBag)
    
    
    if let modelData = model{
      let html =  """
      <html>
      <meta name=\"viewport\" content=\"initial-scale=1.0\" />
      <body>
      \(modelData.contents)
      </body>
      </html>
      """
      webView.loadHTMLString(html, baseURL: nil)
      let attributeString = NSMutableAttributedString(
        string: modelData.title+"   "+modelData.buyPoint+"원"+"\n",
        attributes: [NSAttributedStringKey.font: UIFont.CheeseFontMedium(size: 14)])
      attributeString.append(NSAttributedString(
        string: modelData.brand,
        attributes: [NSAttributedStringKey.font: UIFont.CheeseFontMedium(size: 11),NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)]))
      titleLabel.attributedText = attributeString
      cheesePriceLabel.text = model?.buyPoint
      if let url = model?.imageURL{
        imageView.kf.setImage(with: URL(string: url.getUrlWithEncoding()))
      }
    }
    addConstraint()
  }
  
  
  private func buyAction(){
    guard let model = model else {return}
    let alert = UIAlertController(title: "\(model.title) 상품을 \(model.buyPoint) 치즈로 구매하시겠습니까?" , message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "구매하기", style: .default, handler: {[weak self] (_) in
      guard let `self` = self else {return}
      
      CheeseService.provider
        .request(.buyDirectGift(id: self.model?.id ?? String()))
        .filter(statusCode: 200)
        .mapJSON()
        .map{JSON($0)}
        .asObservable()
        .bind(onNext: self.buyActionSuccess)
        .disposed(by: self.disposeBag)
    }))
    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  private func buyActionSuccess(json: JSON){
    
    
    if json["result"]["code"].intValue == 200{
      let alert = UIAlertController(title: "구매가 완료되었습니다.", message: nil, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "쿠폰보기", style: .default, handler: { _ in
        let navigation = self.navigationController
        navigation?.popViewController(animated: true)
        navigation?.present(MypageNaviViewController(), animated: true, completion: nil)
      }))
      alert.addAction(UIAlertAction(title: "다른상품보기", style: .cancel, handler: {[weak self] _ in
        self?.navigationController?.popViewController(animated: true)
      }))
      self.present(alert, animated: true, completion: nil)
    }else{
      let alert = UIAlertController(title: json["result"]["data"].stringValue, message: nil, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  private func addConstraint(){
    
    buyButton.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(49)
    }
    
    webView.snp.makeConstraints { (make) in
      make.bottom.equalTo(buyButton.snp.top)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalToSuperview().dividedBy(2)
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(5)
      make.right.equalToSuperview()
      make.bottom.equalTo(webView.snp.top)
      make.height.equalTo(50)
    }
    
    imageView.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.top.equalToSuperview()
      make.bottom.equalTo(titleLabel.snp.top)
    }
    
    cheesePriceLabel.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview().inset(10)
      make.centerX.equalToSuperview()
    }
    
    cheeseIcon.snp.makeConstraints { (make) in
      make.centerY.equalTo(cheesePriceLabel)
      make.right.equalTo(cheesePriceLabel.snp.left).offset(-10)
      make.height.equalTo(10)
      make.width.equalTo(10)
    }
  }
}

