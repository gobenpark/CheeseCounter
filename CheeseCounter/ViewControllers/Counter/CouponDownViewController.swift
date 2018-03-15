//
//  CouponDownViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 27..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift
import SwiftyJSON

final class CouponDownViewController: UIViewController{
  
  let model: CouponHistoryViewModel.Item
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
    
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .white
    return imageView
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.backgroundColor = .white
    return label
  }()
  
  let saveButton: UIButton = {
    let button = UIButton()
    button.setTitle("교환권 저장", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = #colorLiteral(red: 1, green: 0.848323524, blue: 0.005472274031, alpha: 1)
    return button
  }()
  
  init(model: CouponHistoryViewModel.Item) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "쿠폰"
    view.addSubview(webView)
    view.addSubview(titleLabel)
    view.addSubview(imageView)
    view.addSubview(saveButton)
    
    CheeseService.provider
      .request(.getMyCouponById(id: model.id))
      .filter(statusCode: 200)
      .mapJSON()
      .map{JSON($0)}
      .subscribe(onSuccess: {[weak self] (json) in
        self?.imageView.image = UIImage(data: Data(base64Encoded: json["result"]["data"]["img"].stringValue)!)
      }) { (error) in
        log.error(error)
      }.disposed(by: disposeBag)
    
    imageView.rx
      .tapGesture()
      .when(.ended)
      .map{[imageView] _ in return imageView.image}
      .subscribe(onNext: {[weak self] image in
        guard let `self` = self else {return}
        self.navigationController?.pushViewController(CouponDetailViewController(image: image), animated: true)
      }).disposed(by: disposeBag)
    
    saveButton.rx.tap
      .subscribe {[weak self] (_) in
        guard let `self` = self else {return}
        if let image = self.imageView.image{
          UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }.disposed(by: disposeBag)
    
    addConstraint()
    dataSetting()
  }

  @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
    if let error = error {
      let ac = UIAlertController(title: "저장 실패", message: "관리자에게 문의하세요", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "확인", style: .default))
      present(ac, animated: true)
    } else {
      let ac = UIAlertController(title: "저장 되었습니다", message: nil, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "확인", style: .default))
      present(ac, animated: true)
    }
  }
  
  private func dataSetting(){
    let html =  """
    <html>
    <meta name=\"viewport\" content=\"initial-scale=1.0\" />
    <body>
    \(model.contents ?? String())
    </body>
    </html>
    """
    webView.loadHTMLString(html, baseURL: nil)
    let attributeString = NSMutableAttributedString(
      string: "\(model.brand ?? String())\n",
      attributes: [.font: UIFont.CheeseFontMedium(size: 11.8),.foregroundColor:#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
    attributeString.append(NSAttributedString(
      string: model.title ?? String(),
      attributes: [.font: UIFont.CheeseFontMedium(size: 11.8)]))
    titleLabel.attributedText = attributeString
    imageView.kf.setImage(with: URL(string: model.img_url.getUrlWithEncoding()))
  }
  
  private func addConstraint(){
    
    saveButton.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(49)
    }
    
    webView.snp.makeConstraints { (make) in
      make.bottom.equalTo(saveButton.snp.top)
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
  }
}
