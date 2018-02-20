////
////  GraphView.swift
////  CheeseCounter
////
////  Created by xiilab on 2017. 3. 7..
////  Copyright © 2017년 xiilab. All rights reserved.
////
//
//import UIKit
//
//import CircleProgressView
//
//class GraphView: UIView {
//
//
//    var didTap:((Int) -> Void)?
//
//    let answerNumberTextView: UITextView = {
//        let textView = UITextView()
//        textView.text = "1,000 / 10,000"
//        textView.backgroundColor = UIColor.cheeseColor()
//        return textView
//    }()
//
//
//    let circleLabels: [UILabel] = {
//        let label = UILabel()
//        let label1 = UILabel()
//        let label2 = UILabel()
//        let label3 = UILabel()
//        let labels = [label,label1,label2,label3]
//        return labels
//    }()
//
//
//    lazy var circleProgressView: CircleView = {
//        let progressView = CircleView()
//        progressView.tag = 0
//        progressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:
//            #selector(pushViewControllerAction)))
//        progressView.backgroundColor = UIColor.cheeseColor()
//        return progressView
//    }()
//
//    lazy var circleProgressView1: CircleView = {
//        let progressView = CircleView()
//        progressView.tag = 1
//        progressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:
//            #selector(pushViewControllerAction)))
//        progressView.backgroundColor = UIColor.cheeseColor()
//        return progressView
//    }()
//    lazy var circleProgressView2: CircleView = {
//        let progressView = CircleView()
//        progressView.tag = 2
//        progressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:
//            #selector(pushViewControllerAction)))
//        progressView.backgroundColor = UIColor.cheeseColor()
//        return progressView
//    }()
//    lazy var circleProgressView3: CircleView = {
//        let progressView = CircleView()
//        progressView.tag = 3
//        progressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:
//            #selector(pushViewControllerAction)))
//        progressView.backgroundColor = UIColor.cheeseColor()
//        return progressView
//    }()
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        circleLabels.forEach {
//            $0.textColor = .white
//            $0.backgroundColor = .clear
//            $0.textAlignment = .center
//            self.addSubview($0)
//        }
//
//        self.addSubview(circleProgressView)
//        self.addSubview(circleProgressView1)
//        self.addSubview(circleProgressView2)
//        self.addSubview(circleProgressView3)
//
//        addConstraint()
//    }
//
//    func addConstraint() {
//
//        let halfSize = UIScreen.main.bounds.width/2
//
//        circleProgressView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.left.equalToSuperview()
//            make.width.equalTo(halfSize)
//            make.height.equalTo(halfSize)
//        }
//
//        circleLabels[0].snp.makeConstraints { (make) in
//            make.top.equalTo(circleProgressView.snp.bottom)
//            make.left.equalToSuperview()
//            make.height.equalTo(30)
//            make.width.equalTo(halfSize)
//        }
//
//        circleProgressView1.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.right.equalToSuperview()
//            make.height.equalTo(halfSize)
//            make.width.equalTo(halfSize)
//        }
//
//        circleLabels[1].snp.makeConstraints { (make) in
//            make.top.equalTo(circleProgressView1.snp.bottom)
//            make.right.equalToSuperview()
//            make.height.equalTo(30)
//            make.width.equalTo(halfSize)
//        }
//
//        circleProgressView2.snp.makeConstraints { (make) in
//            make.top.equalTo(circleLabels[0].snp.bottom)
//            make.left.equalToSuperview()
//            make.width.equalTo(halfSize)
//            make.height.equalTo(halfSize)
//        }
//
//        circleLabels[2].snp.makeConstraints { (make) in
//            make.top.equalTo(circleProgressView2.snp.bottom)
//            make.left.equalToSuperview()
//            make.width.equalTo(halfSize)
//            make.height.equalTo(30)
//        }
//
//        circleProgressView3.snp.makeConstraints { (make) in
//            make.right.equalToSuperview()
//            make.top.equalTo(circleLabels[1].snp.bottom)
//            make.height.equalTo(halfSize)
//            make.width.equalTo(halfSize)
//        }
//
//        circleLabels[3].snp.makeConstraints { (make) in
//            make.right.equalToSuperview()
//            make.top.equalTo(circleProgressView3.snp.bottom)
//            make.height.equalTo(30)
//            make.width.equalTo(halfSize)
//        }
//    }
//
//  @objc func pushViewControllerAction(_ sender: UIGestureRecognizer){
//        guard let tap = self.didTap, let tag = sender.view?.tag else { return }
//        tap(tag)
//    }
//
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//}

