//
//  UsingPrivacyVC.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 5. 2..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit
import WebKit

class UsingPrivacyVC: UIViewController{
    
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
}
