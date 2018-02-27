//
//  LoginViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 2. 27..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit


class WelcomeViewCell: UICollectionViewCell {
  
  var page: Page? {
    didSet {
      guard let page = page else {
        return
      }
      
      //하단 텍스트 필드의 설정
      imageView.image = UIImage(named: page.imageName)
      let attributedText = NSMutableAttributedString(string: page.title
        , attributes: [NSAttributedStringKey.font: UIFont(name: "NotoSansKR-Bold", size: 25)!
          , NSAttributedStringKey.foregroundColor: UIColor.black])
      
      attributedText.append(NSAttributedString(string: "\n\n\(page.message)"
        , attributes: [NSAttributedStringKey.font: UIFont(name: "NotoSansKR-Light", size: 15)!
          , NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
      
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      
      let length = attributedText.string.characters.count
      attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: length))
      
      textView.attributedText = attributedText
    }
  }
  
  let imageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
  
  let textView: UITextView = {
    let tv = UITextView()
    tv.isEditable = false
    tv.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    tv.isScrollEnabled = false
    return tv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  func setupViews() {
    addSubview(imageView)
    addSubview(textView)
    
    imageView.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(100).priority(998)
      make.centerX.equalToSuperview()
      make.width.equalToSuperview().dividedBy(2)
      make.height.equalToSuperview().dividedBy(2.5)
    }
    
    textView.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview().inset(100).priority(997)
      make.top.lessThanOrEqualTo(imageView.snp.bottom).offset(30).priority(998)
      make.height.equalTo(100)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
