//
//  VersionViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 26..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class VersionViewController: UIViewController{
  
    let versionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
  
    fileprivate let logoimg:UIImageView = {
        let img = UIImageView(image: #imageLiteral(resourceName: "logo"))
        return img
    }()
  
    fileprivate lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.CheeseFontBold(size: 18)
        label.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.sizeToFit()
        return label
    }()
  
    fileprivate let appVersionLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.font = UIFont.CheeseFontLight(size: 14)
        return label
    }()
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "버전정보"
        self.view.backgroundColor = .lightGray
      
        self.view.addSubview(versionView)
        self.versionView.addSubview(logoimg)
        self.versionView.addSubview(appNameLabel)
        self.versionView.addSubview(appVersionLabel)
      
        if let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            appNameLabel.text = appName
        }
      
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersionLabel.text = appVersion
        }
      
        versionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(100)
        }
      
        logoimg.snp.makeConstraints { (make) in
            make.left.equalTo(versionView).inset(25)
            make.centerY.equalTo(versionView)
        }
      
        appNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(logoimg.snp.right).offset(10)
            make.top.equalTo(logoimg)
        }
      
        appVersionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(appNameLabel.snp.bottom)
            make.left.equalTo(appNameLabel)
        }
    }
}

