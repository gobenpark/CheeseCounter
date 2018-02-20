//
//  BaseSetupViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 30..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class BaseSetupViewController: UIViewController{
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()

    var isdisableScroll: Bool = true
    weak var userSetupViewController: UserSetupViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(titleLabel)
        
        let topSize = UIApplication.shared.statusBarFrame.height
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        gesture.direction = .left
        gesture.delegate = self
        let longtapGesture = UILongPressGestureRecognizer(target: self, action: #selector(emptyAction))
        longtapGesture.delegate = self
        self.view.addGestureRecognizer(gesture)
        self.view.addGestureRecognizer(longtapGesture)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin).inset(topSize)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(60)
        }

        setup()
    }

    func setup(){}
  @objc dynamic func swipeAction(){}
  @objc private dynamic func emptyAction(){}
}

extension BaseSetupViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return isdisableScroll
    }
}
