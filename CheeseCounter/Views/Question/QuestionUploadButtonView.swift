//
//  UploadButtonView.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 22..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class QuestionUploadButtonView: UIView {
  
  var uploadTap: (() -> Void)?
  
  lazy var upLoadButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = #colorLiteral(red: 1, green: 0.4, blue: 0.1882352941, alpha: 1)
    button.setTitle("내 질문 올리기", for: .normal)
    button.titleLabel?.font = UIFont.CheeseFontBold(size: 15.1)
    button.addTarget(self, action: #selector(uploadAction), for: .touchUpInside)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setUp(){
    self.backgroundColor = .white
    
    addSubview(upLoadButton)
    
    upLoadButton.snp.makeConstraints { (make) in
      make.top.equalTo(snp.topMargin)
      make.left.equalToSuperview().inset(25)
      make.right.equalToSuperview().inset(25)
      make.bottom.equalTo(snp.bottomMargin)
    }
  }
  
  @objc func uploadAction(){
    let alertController = UIAlertController(title: "", message: "등록하시겠습니까?", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "취소", style: .destructive, handler: nil))
    alertController.addAction(UIAlertAction(title: "예", style: .cancel, handler: { [weak self] (_) in
      guard let tap = self?.uploadTap else {return}
      tap()
    }))
    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
  }
}
