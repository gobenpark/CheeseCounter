//
//  File.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 26..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import BetterSegmentedControl

class QnAViewController: UIViewController {
    
    lazy var setUpPageViewController: SetUpPageViewController = {
        let viewController = SetUpPageViewController(
            transitionStyle: .scroll
            , navigationOrientation: .horizontal
            , options: nil)
        viewController.Delegate = self
        return viewController
    }()
    
    lazy var viewControllers: [UIViewController] = {
        var VCS: [UIViewController] = []
        VCS.append(InquireViewController())
        VCS.append(MyInquireViewController())
        return VCS
    }()

    lazy var extendView: ExtendedNavBarView = {
        let view = ExtendedNavBarView()
        view.segmentedControl.titles = ["문의하기","나의문의"]
        view.segmentedControl.addTarget(self, action: #selector(extendAction(_:)), for: .valueChanged)
        return view
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.setUpPageViewController.pageViewControllers = viewControllers
        self.addChildViewController(setUpPageViewController)
        self.view.backgroundColor = .white
        self.view.addSubview(setUpPageViewController.view)
        self.view.addSubview(extendView)
        
        extendView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(80)
        }
        setUpPageViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(extendView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    fileprivate dynamic func extendAction(_ sender: BetterSegmentedControl){
        self.setUpPageViewController.scrollToViewController(index: Int(sender.index))
    }
}

extension QnAViewController: SetUpPageViewControllerDelegate {
    
    func setUpPageViewController(_ PageViewController: SetUpPageViewController, didUpdatePageCount count: Int) {
        
    }
    
    func setUpPageViewController(_ PageViewController: SetUpPageViewController,didUpdatePageIndex index: Int) {
        do {
            try extendView.segmentedControl.setIndex(UInt(index))
        } catch let error{
            log.error(error.localizedDescription)
        }

    }
}

