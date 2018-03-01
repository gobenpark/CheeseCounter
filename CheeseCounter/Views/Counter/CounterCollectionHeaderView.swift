//
//  CounterCollectionHeaderView.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 2. 27..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import SwiftyJSON


class CounterCollectionHeaderView: UICollectionReusableView{
  
  private let disposeBag = DisposeBag()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.contentMode = UIViewContentMode.left
    return label
  }()
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleLabel)
    backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
    addConstraint()
  }
  
  private func addConstraint(){
    titleLabel.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.left.equalToSuperview().inset(10)
    }
  }
  
  override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)
    CheeseService.provider.request(.getMyPoint)
      .mapJSON()
      .map{JSON($0)}
      .subscribe(onSuccess: { [weak self](json) in
        let attribute = NSMutableAttributedString(string: "보유치즈: \(json["result"]["data"]["cheese"].intValue.stringFormattedWithSeparator())\n",
          attributes: [.foregroundColor:#colorLiteral(red: 1, green: 0.4705882353, blue: 0.2862745098, alpha: 1), .font: UIFont.CheeseFontMedium(size: 11)])
        attribute.append(NSAttributedString(string: "상품을 선택하면 게임을 통해 상품을 가져갈 수 있어요!",
                                            attributes: [.font: UIFont.CheeseFontRegular(size: 11),.foregroundColor:#colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)]))
        self?.titleLabel.attributedText = attribute
        self?.titleLabel.sizeToFit()
        
      }) {[weak self] (error) in
        let attribute = NSMutableAttributedString(string: "보유치즈: 0\n",
          attributes: [.foregroundColor:#colorLiteral(red: 1, green: 0.4705882353, blue: 0.2862745098, alpha: 1), .font: UIFont.CheeseFontMedium(size: 11)])
        attribute.append(NSAttributedString(string: "상품을 선택하면 게임을 통해 상품을 가져갈 수 있어요!",
                                            attributes: [.font: UIFont.CheeseFontRegular(size: 11),.foregroundColor:#colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)]))
        self?.titleLabel.attributedText = attribute
        self?.titleLabel.sizeToFit()
      }.disposed(by: disposeBag)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
