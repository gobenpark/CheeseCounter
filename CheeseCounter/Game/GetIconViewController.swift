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
  
  let backButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(#imageLiteral(resourceName: "btnGameBackRoulette"), for: .normal)
    return button
  }()
  
  let icon: UIImageView = UIImageView()
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
  }

  init(icon: UIImage) {
    self.icon.image = icon
    super.init(nibName: nil, bundle: nil)
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
    
    backButton.rx.tap
      .subscribe {[weak self] (event) in
        guard let retainSelf = self else {return}
        retainSelf.dismiss(animated: true, completion: retainSelf.dismissAction)}
      .disposed(by: disposeBag)
  }
}
