//
//  UsingServiceClauseVC.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 27..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit
import WebKit

class UsingServiceClauseVC: UIViewController{
    
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
}
