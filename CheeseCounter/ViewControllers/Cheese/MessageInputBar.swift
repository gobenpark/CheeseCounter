//
//  ReplyTextView.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 20..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import NextGrowingTextView
import RxSwift
import RxCocoa
import RxKeyboard

struct ReplyActionData{
  let nickname: String
  let parentID: String
}

enum ReplyAction{
  case Reply
  case ReReply(replyData: ReplyActionData)
}

final class MessageInputBar: UIView{
  
  private let disposeBag = DisposeBag()
  var parentId: String = String()
  
  private let toolbar = UIToolbar()
  lazy var textView: NextGrowingTextView = {
    let textView = NextGrowingTextView()
    textView.backgroundColor = .white
    textView.placeholderAttributedText = NSAttributedString(string: "댓글을 입력하세요..."
      ,attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15)
        ,NSAttributedStringKey.foregroundColor: UIColor.gray])
    textView.sizeToFit()
    return textView
  }()
  
  let sendButton: UIButton = {
    let button = UIButton(type: .system)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    button.setTitle("입력",for: .normal)
    return button
  }()
  
  var replyType: ReplyAction = .Reply{
    didSet{
      switch replyType{
      case .Reply:
        self.parentId = String()
      self.textView.placeholderAttributedText = NSAttributedString(string: "댓글을 입력하세요..."
        ,attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15)
          ,NSAttributedStringKey.foregroundColor: UIColor.gray])
      case .ReReply(let replyData):
        self.parentId = replyData.parentID
        self.textView.placeholderAttributedText = NSAttributedString(string: "\(replyData.nickname)에게 댓글을 다는중..."
          ,attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15)
            ,NSAttributedStringKey.foregroundColor: UIColor.gray])
      }
    }
  }
  
  override init(frame: CGRect){
    super.init(frame:frame)
    
    self.addSubview(toolbar)
    self.addSubview(textView)
    self.addSubview(sendButton)
    
    addConstraint()
    
    RxKeyboard.instance.visibleHeight
      .map { $0 > 0 }
      .drive(onNext: { [weak self] (visible) in
        guard let `self` = self else {
          return
        }
        
        var bottomInset: CGFloat = 0
        if #available(iOS 11.0, *), !visible, let bottom = self.superview?.safeAreaInsets.bottom {
          bottomInset = bottom
        }
        
        self.toolbar.snp.remakeConstraints({ (make) in
          make.left.right.top.equalTo(0)
          make.bottom.equalTo(bottomInset)
        })
      })
      .disposed(by: self.disposeBag)
    
    
    textView.textView
      .rx
      .text
      .filterNil()
      .map { Int($0.count) >= 2}
      .bind(to: sendButton.rx.isEnabled)
      .disposed(by:disposeBag)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @available(iOS 11.0, *)
  override func safeAreaInsetsDidChange() {
    super.safeAreaInsetsDidChange()
    guard let bottomInset = self.superview?.safeAreaInsets.bottom else {
      return
    }
    
    self.toolbar.snp.remakeConstraints { make in
      make.top.left.right.equalTo(0)
      make.bottom.equalTo(bottomInset)
    }
  }
  
  func reloadData(){
    textView.textView.text = String()
    textView.textView.resignFirstResponder()
    self.replyType = .Reply
  }
  
  private func addConstraint(){
    toolbar.snp.makeConstraints { make in
      make.edges.equalTo(0)
    }
    
    textView.snp.makeConstraints { make in
      make.left.equalTo(7)
      make.right.equalTo(self.sendButton.snp.left).offset(-7)
      make.bottom.equalTo(-7)
    }
    
    sendButton.snp.makeConstraints { make in
      make.top.equalTo(7)
      make.bottom.equalTo(-7)
      make.right.equalTo(-7)
    }
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: self.bounds.size.width, height: 44)
  }
}

