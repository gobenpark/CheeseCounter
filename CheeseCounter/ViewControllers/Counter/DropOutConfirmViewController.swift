//
//  DropOutConfirmViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 5. 4..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class DropOutConfirmViewController: UIViewController {
    let titleLabel: UILabel = {
       let label = UILabel()
        label.sizeToFit()
        label.text = "탈퇴요청 신청중입니다.\n탈퇴요청을 철회 하시려면 하단의 버튼을 눌러주세요."
        return label
    }()
  
    lazy var button: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "btn_gradation@1x"), for: .normal)
        button.setTitle("철회하기", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
  
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(titleLabel)
        self.view.addSubview(button)
      
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }
      
        button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().inset(26)
            make.right.equalToSuperview().inset(26)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
    }
  
  @objc fileprivate dynamic func buttonAction(_ sender: UIButton){
        CheeseService.deleteSecession { (code) in
            if code == "200"{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

