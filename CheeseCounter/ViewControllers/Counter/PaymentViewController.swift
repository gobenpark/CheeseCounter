//
//  PaymentViewController.swift
//  CheeseCounter
//
//  Created by 박범우 on 2017. 4. 6..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import Crashlytics

class PaymentViewController: UIViewController{
  let urlString = "\(UserService.url)/payment/nicepay?"
  
  lazy var webView: UIWebView = {
    let webView = UIWebView()
    webView.delegate = self
    return webView
  }()
  
  let activityView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    view.frame = UIScreen.main.bounds
    return view
  }()
  
  var paymentData: PayData?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view = webView
    
    self.view.addSubview(activityView)
    AppDelegate.instance?.paymentViewController = self
    
    let button = UIBarButtonItem(title: "주문취소", style: .plain, target: self, action: #selector(payCancel))
    button.tintColor = .black
    self.navigationItem.rightBarButtonItem = button
    
    guard let pay = paymentData else {return}
    guard let myURL = URL(string: urlString+"pay_method=\(pay.pay_method)&gold=" +
      "\(pay.gold)&amount=\(pay.amount)&access_token=\(pay.access_token)")
      else {return}
    let request = URLRequest(url: myURL)
    
    webView.loadRequest(request)
  }
  @objc fileprivate dynamic func payCancel(){
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }
  
  func requesIspPayResult(urlString: String){
    //isp인증 후 복귀했을 때 결제 후속조치
    guard let url = URL(string: urlString) else {return}
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    webView.loadRequest(request)
  }
  
  
  func showAlertViewWithMessage(msg: String,tag: Int){
    let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "확인", style: .default) { (_) in
      switch tag {
      case 99:
        let URLString = "https://itunes.apple.com/app/mobail-gyeolje-isp/id369125087?mt=8"
        guard let storeURL = URL(string: URLString) else {return}
        if #available(iOS 10.0, *) {
          UIApplication.shared.open(storeURL, options: [:], completionHandler: nil)
        } else {
          // Fallback on earlier versions
        }
      case 88:
        let URLString = "https://itunes.apple.com/app/eunhaeng-gongdong-gyejwaiche/id398456030?mt=8"
        guard let storeURL = URL(string: URLString) else {return}
        if #available(iOS 10.0, *) {
          UIApplication.shared.open(storeURL, options: [:], completionHandler: nil)
        } else {
          // Fallback on earlier versions
        }
      case 77:
        let URLString = "https://itunes.apple.com/kr/app/kbgugmin-aebkadue/id695436326?mt=8"
        guard let storeURL = URL(string: URLString) else {return}
        if #available(iOS 10.0, *) {
          UIApplication.shared.open(storeURL, options: [:], completionHandler: nil)
        } else {
          // Fallback on earlier versions
        }
      case 66:
        let URLString = "https://itunes.apple.com/kr/app/mpokes/id535125356?mt=8&ls=1"
        guard let storeURL = URL(string: URLString) else {return}
        if #available(iOS 10.0, *) {
          UIApplication.shared.open(storeURL, options: [:], completionHandler: nil)
        } else {
          // Fallback on earlier versions
        }
        
      default:
        break
      }
    }
    alertController.addAction(alertAction)
    self.present(alertController, animated: true, completion: nil)
  }
}

extension PaymentViewController: UIWebViewDelegate{
  
  func webViewDidStartLoad(_ webView: UIWebView) {
    activityView.startAnimating()
    
  }
  
  func webViewDidFinishLoad(_ webView: UIWebView) {
    activityView.stopAnimating()
    guard let urlString = webView.request?.url?.absoluteString else {return}
    if urlString.contains("imp_success=true") {
      if let data = self.paymentData{
        Answers.logPurchase(withPrice: NSDecimalNumber(string: data.amount), currency: "KRW", success: true, itemName: "골드:\(data.gold)", itemType: "골드", itemId: nil, customAttributes: nil)
      }
      self.presentingViewController?.dismiss(animated: true, completion: nil)
    }else if urlString.contains("imp_success=false"){
      let alertController = UIAlertController(title: "결제 실패", message: "", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
        if let data = self.paymentData{
          Answers.logPurchase(withPrice: NSDecimalNumber(string: data.amount), currency: "KRW", success: false, itemName: "골드:\(data.gold)", itemType: "골드", itemId: nil, customAttributes: nil)
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
      }))
      AppDelegate.instance?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
  }
  
  func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    let appShared = UIApplication.shared
    
    guard let urlString = request.url?.absoluteString,
      let url = request.url else { return false}
    print("current 😆 : \(urlString.contains("imp_success=true"))")
    
    
    //app store URL 여부 확인
    let goAppStore = urlString.contains("phobos.apple.com")
    let goAppStore2 = urlString.contains("itunes.apple.com")
    //app store 로 연결하는 경우 앱스토어 APP을 열어 준다. (isp, bank app 을 설치하고자 경우)
    if goAppStore || goAppStore2 {
      if #available(iOS 10.0, *),let url = request.url {
        appShared.open(url, options: [:], completionHandler: nil)
      } else {
        appShared.openURL(url)
      }
      return false
    }
    
    //isp App을 호출하는 경우
    if urlString.hasPrefix("ispmobile://") {
      
      if appShared.canOpenURL(url) {
        if #available(iOS 10.0, *),let url = request.url  {
          appShared.open(url, options: [:], completionHandler: nil)
        } else {
          appShared.openURL(url)
        }
      }
      else {
        self.showAlertViewWithMessage(msg: "모바일 ISP가 설치되어 있지 않아\nApp Store로 이동합니다.", tag: 99)
        return false
      }
    }
    
    //Kb 앱
    if urlString.hasPrefix("kb-acp://") {
      if appShared.canOpenURL(url) {
        if #available(iOS 10.0, *),let url = request.url  {
          appShared.open(url, options: [:], completionHandler: nil)
        } else {
          appShared.openURL(url)
        }
      }
      else {
        self.showAlertViewWithMessage(msg: "앱카드가 설치되어 있지 않아\nApp Store로 이동합니다.", tag: 77)
        return false
      }
    }
    
    if urlString.hasPrefix("mpocket.online.ansimclick://"){
      if appShared.canOpenURL(url){
        if #available(iOS 10.0, *),let url = request.url  {
          appShared.open(url, options: [:], completionHandler: nil)
        } else {
          appShared.openURL(url)
        }
      } else {
        self.showAlertViewWithMessage(msg: "앱카드가 설치되어 있지 않아\nApp Store로 이동합니다.", tag: 66)
        return false
      }
    }
    
    return true
    
  }
}
/*
 class PaymentViewController: UIViewController{
 
 
 let urlString = "\(UserService.url)/payment/nicepay?"
 
 lazy var webView: WKWebView = {
 let webConfiguration = WKWebViewConfiguration()
 webConfiguration.processPool = WKProcessPool()
 let webView = WKWebView(frame: .zero, configuration: webConfiguration)
 webView.uiDelegate = self
 webView.navigationDelegate = self
 return webView
 }()
 
 
 var paymentData: PayData?
 var bankPayUrlString: String?
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 self.view = webView
 //        AppDelegate.instance?.paymentViewController = self
 
 let button = UIBarButtonItem(title: "주문취소", style: .plain, target: self, action: #selector(payCancel))
 button.tintColor = .black
 self.navigationItem.rightBarButtonItem = button
 
 guard let pay = paymentData else {return}
 guard let myURL = URL(string: urlString+"pay_method=\(pay.pay_method)&gold=" +
 "\(pay.gold)&amount=\(pay.amount)&access_token=\(pay.access_token)")
 else {return}
 var request = URLRequest(url: myURL)
 var cookies = HTTPCookie.requestHeaderFields(with: HTTPCookieStorage.shared.cookies(for: request.url!)!)
 if let value = cookies["Cookie"]{
 request.addValue(value, forHTTPHeaderField: "Cookie")
 }
 
 
 webView.load(request)
 }
 
 fileprivate dynamic func payCancel(){
 self.presentingViewController?.dismiss(animated: true, completion: nil)
 }
 
 func requesIspPayResult(urlString: String){
 //isp인증 후 복귀했을 때 결제 후속조치
 guard let url = URL(string: urlString) else {return}
 var request = URLRequest(url: url)
 request.httpMethod = "GET"
 webView.load(request)
 }
 
 func showAlertViewWithMessage(msg: String,tag: Int){
 let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
 let alertAction = UIAlertAction(title: "확인", style: .default) { (_) in
 switch tag {
 case 99:
 let URLString = "https://itunes.apple.com/app/mobail-gyeolje-isp/id369125087?mt=8"
 guard let storeURL = URL(string: URLString) else {return}
 if #available(iOS 10.0, *) {
 UIApplication.shared.open(storeURL, options: [:], completionHandler: nil)
 } else {
 // Fallback on earlier versions
 }
 case 88:
 let URLString = "https://itunes.apple.com/app/eunhaeng-gongdong-gyejwaiche/id398456030?mt=8"
 guard let storeURL = URL(string: URLString) else {return}
 if #available(iOS 10.0, *) {
 UIApplication.shared.open(storeURL, options: [:], completionHandler: nil)
 } else {
 // Fallback on earlier versions
 }
 case 77:
 let URLString = "https://itunes.apple.com/kr/app/kbgugmin-aebkadue/id695436326?mt=8"
 guard let storeURL = URL(string: URLString) else {return}
 if #available(iOS 10.0, *) {
 UIApplication.shared.open(storeURL, options: [:], completionHandler: nil)
 } else {
 // Fallback on earlier versions
 }
 case 66:
 let URLString = "https://itunes.apple.com/kr/app/mpokes/id535125356?mt=8&ls=1"
 guard let storeURL = URL(string: URLString) else {return}
 if #available(iOS 10.0, *) {
 UIApplication.shared.open(storeURL, options: [:], completionHandler: nil)
 } else {
 // Fallback on earlier versions
 }
 
 default:
 break
 }
 }
 alertController.addAction(alertAction)
 self.present(alertController, animated: true, completion: nil)
 }
 }
 
 extension PaymentViewController: WKUIDelegate{
 
 }
 
 extension PaymentViewController: WKNavigationDelegate{
 
 
 func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
 let headerFields = navigationAction.request.allHTTPHeaderFields
 
 
 let appShared = UIApplication.shared
 
 guard var urlString = navigationAction.request.url?.absoluteString,
 let url = navigationAction.request.url else { return }
 print("current 😆 : \(urlString.contains("imp_success=true"))")
 print(urlString)
 
 
 //app store URL 여부 확인
 let goAppStore = urlString.contains("phobos.apple.com")
 let goAppStore2 = urlString.contains("itunes.apple.com")
 //app store 로 연결하는 경우 앱스토어 APP을 열어 준다. (isp, bank app 을 설치하고자 경우)
 if goAppStore || goAppStore2 {
 if #available(iOS 10.0, *),let url = webView.url {
 appShared.open(url, options: [:], completionHandler: nil)
 } else {
 appShared.openURL(url)
 }
 decisionHandler(.cancel)
 }
 
 //isp App을 호출하는 경우
 if urlString.hasPrefix("ispmobile://") {
 
 if appShared.canOpenURL(url) {
 if #available(iOS 10.0, *),let url = webView.url  {
 appShared.open(url, options: [:], completionHandler: nil)
 } else {
 appShared.openURL(url)
 }
 }
 else {
 self.showAlertViewWithMessage(msg: "모바일 ISP가 설치되어 있지 않아\nApp Store로 이동합니다.", tag: 99)
 decisionHandler(.cancel)
 }
 }
 
 //Kb 앱
 if urlString.hasPrefix("kb-acp://") {
 if appShared.canOpenURL(url) {
 if #available(iOS 10.0, *),let url = webView.url  {
 appShared.open(url, options: [:], completionHandler: nil)
 } else {
 appShared.openURL(url)
 }
 }
 else {
 self.showAlertViewWithMessage(msg: "앱카드가 설치되어 있지 않아\nApp Store로 이동합니다.", tag: 77)
 decisionHandler(.cancel)
 }
 }
 
 if urlString.hasPrefix("mpocket.online.ansimclick://"){
 if appShared.canOpenURL(url){
 if #available(iOS 10.0, *),let url = webView.url  {
 appShared.open(url, options: [:], completionHandler: nil)
 } else {
 appShared.openURL(url)
 }
 } else {
 self.showAlertViewWithMessage(msg: "앱카드가 설치되어 있지 않아\nApp Store로 이동합니다.", tag: 66)
 decisionHandler(.cancel)
 }
 }
 
 switch navigationAction.navigationType {
 case .linkActivated:
 if navigationAction.targetFrame == nil || !navigationAction.targetFrame!.isMainFrame {
 webView.load(URLRequest(url: url))
 decisionHandler(.cancel)
 return
 }
 default:
 break
 }
 
 decisionHandler(.allow)
 }
 func webViewDidClose(_ webView: WKWebView) {
 self.presentingViewController?.dismiss(animated: true, completion: nil)
 }
 
 func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
 guard let url = navigationAction.request.url else {
 return nil
 }
 guard navigationAction.targetFrame != nil  else {
 webView.load(URLRequest(url: url))
 return nil
 }
 return nil
 }
 func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
 
 guard var urlString = webView.url?.absoluteString else {return}
 if urlString.contains("imp_success=true") {
 self.presentingViewController?.dismiss(animated: true, completion: nil)
 }
 }
 
 func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
 if let urlResponse = navigationResponse.response as? HTTPURLResponse,
 let url = urlResponse.url,
 let allHeaderFields = urlResponse.allHeaderFields as? [String : String] {
 let cookies = HTTPCookie.cookies(withResponseHeaderFields: allHeaderFields, for: url)
 HTTPCookieStorage.shared.setCookies(cookies , for: urlResponse.url!, mainDocumentURL: nil)
 decisionHandler(.allow)
 }
 }
 }
 */
