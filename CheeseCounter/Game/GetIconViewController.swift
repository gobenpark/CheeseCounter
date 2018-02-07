//
//  GetIconViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2018. 1. 29..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class GetIconViewController: UIViewController{
  
  let disposeBag = DisposeBag()
  var dismissAction: (()->Void)?
  let imageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "counterGameBg"))
    imageView.contentMode = .center
    imageView.layer.masksToBounds = true
    return imageView
  }()
  
  let centerCircle: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.8901960784, blue: 0.3529411765, alpha: 1)
    view.layer.masksToBounds = true
    return view
  }()
  
  var currentStage: StageStatus
  
  var iconImage: UIImage = UIImage()
  
  let outsideLabel: UILabel = UILabel()
  
  let backButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(#imageLiteral(resourceName: "btnGameBackRoulette"), for: .normal)
    return button
  }()
  
  let icon: UIImageView = UIImageView()
  
  init(icon: UIImage, stage: StageStatus) {
    self.icon.image = icon
    self.iconImage = icon
    self.currentStage = stage
    super.init(nibName: nil, bundle: nil)
  }
  
  private func matcher(icon: UIImage) -> String{
    if icon == #imageLiteral(resourceName: "cheeseEmental"){
      return "에멘탈"
    }else if icon == #imageLiteral(resourceName: "cheeseGorgonzola"){
      return "고르곤졸라"
    }else if icon == #imageLiteral(resourceName: "cheeseBrie"){
      return "브리"
    }else if icon == #imageLiteral(resourceName: "cheeseColbyjack"){
      return "콜비잭"
    }else if icon == #imageLiteral(resourceName: "cheeseGauda"){
      return "고다"
    }else if icon == #imageLiteral(resourceName: "cheeseHavati"){
      return "하바티"
    }else if icon == #imageLiteral(resourceName: "cheeseBrick"){
      return "브릭"
    }
    return String()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    view.addSubview(imageView)
    view.backgroundColor = .white
    view.addSubview(backButton)
    view.addSubview(centerCircle)
    view.addSubview(outsideLabel)
    centerCircle.addSubview(icon)
    
    imageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    backButton.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview().inset(50)
      make.centerX.equalToSuperview()
      make.height.equalTo(49.5)
      make.width.equalTo(289)
    }
    
    centerCircle.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(180)
      make.width.equalTo(150)
      make.height.equalTo(150)
    }
    centerCircle.layer.cornerRadius = 150/2
    
    icon.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.width.equalTo(70)
      make.height.equalTo(100)
    }
    
    outsideLabel.snp.makeConstraints { (make) in
      make.top.equalTo(centerCircle.snp.bottom).offset(27)
      make.centerX.equalToSuperview()
    }
    outsideLabel.numberOfLines = 2
    
    let attribute = NSAttributedString(
      string: "+ \(self.matcher(icon: iconImage)) 획득!\n+ 남은 횟수 \(3-self.currentStage.rawValue)회",
      attributes: [NSAttributedStringKey.font: UIFont.CheeseFontMedium(size: 20),
                   NSAttributedStringKey.foregroundColor: UIColor.white,
                   NSAttributedStringKey.strokeColor: UIColor(red: 1.0, green: 0.564, blue: 0.342, alpha: 1.0),
                   NSAttributedStringKey.strokeWidth: 4.5])
    
    outsideLabel.attributedText = attribute
    outsideLabel.sizeToFit()
    
    backButton.rx.tap
      .subscribe {[weak self] (event) in
        guard let retainSelf = self else {return}
        retainSelf.dismiss(animated: true, completion: retainSelf.dismissAction)}
      .disposed(by: disposeBag)
  }
}
