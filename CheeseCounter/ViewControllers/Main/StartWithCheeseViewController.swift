//
//  WelcomeCoachViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 8. 1..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa

class StartWithCheeseViewController: UIViewController{

  let disposeBag = DisposeBag()
  var didTap: (()->Void)?
  private let mainTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "치즈 보상 획득!"
    label.font = UIFont.CheeseFontBold(size: 19)
    return label
  }()
  
  private let imgView: UIImageView = {
    let view = UIImageView(image: #imageLiteral(resourceName: "bg_gradation@1x"))
    return view
  }()
  
  private let goldImg: LOTAnimationView = {
    let view = LOTAnimationView(name: "gold_reward")
    view.animationSpeed = 0.5
    return view
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    let attribute = NSMutableAttributedString(string: "+ 500치즈", attributes: [NSAttributedStringKey.font:UIFont.CheeseFontBold(size: 30),NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.9979653955, green: 0.4697954655, blue: 0.2858062387, alpha: 1)])
    attribute.append(NSAttributedString(string: "\n\n카운터에서 치즈내역을 확인하세요!",
                                        attributes: [
                                          NSAttributedStringKey.font:UIFont.CheeseFontBold(size: 18),
                                          NSAttributedStringKey.foregroundColor:UIColor.lightGray]))
    label.adjustsFontSizeToFitWidth = true
    label.attributedText = attribute
    label.numberOfLines = 3
    label.textAlignment = .center
    return label
  }()
  
  private lazy var dismissButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "btn_next@1x"), for: .normal)
    button.sizeToFit()
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(mainTitleLabel)
    view.addSubview(goldImg)
    view.addSubview(titleLabel)
    view.addSubview(dismissButton)
    view.backgroundColor = .white
    
    dismissButton.rx
      .tap
      .subscribe{[weak self] _ in
        guard let tap = self?.didTap else {return}
        tap()
    }.disposed(by: disposeBag)
    
    addConstraint()
  }
  
  func addConstraint(){
    mainTitleLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(80)
      make.height.equalTo(50)
      make.centerX.equalToSuperview()
    }
    
    goldImg.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(mainTitleLabel.snp.bottom).offset(5)
      make.width.equalTo(goldImg.snp.height)
      make.bottom.equalTo(titleLabel.snp.top)
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.bottom.equalTo(dismissButton.snp.top).offset(-50)
      make.centerX.equalToSuperview()
      make.height.equalTo(100)
    }
    
    dismissButton.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.height.equalTo(50)
      make.width.equalTo(50)
      make.bottom.equalToSuperview().inset(52)
    }
    
    self.goldImg.play()
  }
}
