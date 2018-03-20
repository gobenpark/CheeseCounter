//
//  File.swift
//  CheeseCounter
//
//  Created by park bumwoo on 2018. 3. 1..
//  Copyright © 2018년 xiilab. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class EventViewController: UIViewController{
  
  private let disposeBag = DisposeBag()
  
  var modalFlag = false
  var model: [EventModel.Data]?
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  let detailButton: UIButton = {
    let button = UIButton()
    button.setTitle("자세히보기", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.CheeseFontMedium(size: 13.4)
    button.backgroundColor = .white
    return button
  }()
  
  let cancelButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "btnClose"), for: .normal)
    return button
  }()
  
  init(model: [EventModel.Data]) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(imageView)
    view.addSubview(detailButton)
    imageView.addSubview(cancelButton)
    
    cancelButton.rx
      .tap
      .subscribe {[weak self] (_) in
      self?.dismiss(animated: true, completion: nil)
    }.disposed(by: disposeBag)
    
    detailButton.rx
      .tap
      .subscribe { (_) in
        log.info("gogo")
      }.disposed(by: disposeBag)
    
    addConstraint()
    
    guard let url = model?.first?.img_url else {return}
    imageView.kf.setImage(with: URL(string: url.getUrlWithEncoding()))
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    guard var model = model ,!modalFlag else {return}
    if model.count > 1 {
      model.removeFirst()
      self.present(EventViewController(model: model), animated: false, completion: nil)
    }
    modalFlag = true
  }
  
  private func addConstraint(){
    imageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 168, left: 39, bottom: 200, right: 39))
    }
    
    detailButton.snp.makeConstraints { (make) in
      make.left.right.equalTo(imageView)
      make.top.equalTo(imageView.snp.bottom)
      make.height.equalTo(50)
    }
    
    cancelButton.snp.makeConstraints { (make) in
      make.right.top.equalToSuperview().inset(10)
      make.height.width.equalTo(30)
    }
  }
}
