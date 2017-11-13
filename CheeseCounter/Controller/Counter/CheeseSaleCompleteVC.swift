//
//  CheeseSaleCompleteVC.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 5. 8..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class CheeseSaleCompleteVC: UIViewController{
    
    var callBack: (() -> Void)?
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.sizeToFit()
        label.font = UIFont.CheeseFontBold(size: 24)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    var subTitleLabel: UILabel = {
        var label = UILabel()
        label.sizeToFit()
        label.font = UIFont.CheeseFontBold(size: 14)
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textColor = #colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
        return label
    }()
    
    fileprivate let mainImgView: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg_illust_gold_sell"))
        return img
    }()
    
    fileprivate let returnButton: UIButton = {
        let button = UIButton()
        button.setTitle("카운터로 돌아가기", for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "btn_gradation@1x"), for: .normal)
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)
        self.view.addSubview(mainImgView)
        self.view.addSubview(returnButton)
        self.modalPresentationStyle = .popover
        addConstraint()
    }
    
    func addConstraint(){
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(73)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(21)
            make.left.equalToSuperview().inset(26)
            make.right.equalToSuperview().inset(26)
            make.centerX.equalToSuperview()
        }
        
        mainImgView.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLabel.snp.bottom)
            make.left.equalToSuperview().inset(26)
            make.right.equalToSuperview().inset(26)
        }
        
        returnButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(26)
            make.right.equalToSuperview().inset(26)
            make.height.equalTo(47)
            make.top.equalTo(mainImgView.snp.bottom).offset(24)
            make.bottom.equalToSuperview().inset(63)
        }
    }
    
    //MARK: - ACTION
  @objc func dismissAction(){
        self.presentingViewController?.dismiss(animated: true, completion: {
            guard let callBack = self.callBack else {return}
            callBack()
        })
    }
}
