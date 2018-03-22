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
import SwiftyUserDefaults

class EventViewController: UIViewController{
  
  private let disposeBag = DisposeBag()
  
  var modalFlag = false
  var model: EventModel.Data
  var childVC: EventViewController?
  
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
  
  let item = UIBarButtonItem(title: "닫기", style: .done, target: nil, action: nil)
  lazy var eventPage: CounterEventViewController = {
    let vc = CounterEventViewController()
    vc.id = self.model.id
    return vc
  }()
  
  init(model: EventModel.Data) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
    self.modalPresentationStyle = .overCurrentContext
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard let vc = childVC , !modalFlag else {return}
    self.present(vc, animated: false, completion: nil)
    modalFlag = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(imageView)
    view.addSubview(detailButton)
    imageView.addSubview(cancelButton)
    
    cancelButton.rx
      .tap
      .do(onNext: {[model] (_) in
        Defaults[.popUpIDs].append(model.id)
      })
      .subscribe {[weak self] (_) in
      self?.dismiss(animated: true, completion: nil)
    }.disposed(by: disposeBag)
    
    //      .do(onNext: {[model] (_) in
    //        Defaults[.popUpIDs].append(model.id)
    //      })
    
    detailButton.rx
      .tap
      .subscribe {[weak self] (item) in
        guard let `self` = self else {return}
        self.eventPage.navigationItem.setRightBarButton(self.item, animated: true)
        self.eventPage.modalPresentationStyle = .overCurrentContext
        self.present(UINavigationController(rootViewController: self.eventPage), animated: true, completion: nil)
      }.disposed(by: disposeBag)
    
    item.rx
      .tap
      .subscribe {[weak self] (_) in
        self?.eventPage.dismiss(animated: true, completion: {[weak self] in
          self?.dismiss(animated: true, completion: nil)
        })
    }.disposed(by: disposeBag)

    addConstraint()
    imageView.kf.setImage(with: URL(string: model.img_url?.getUrlWithEncoding() ?? String()))
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
