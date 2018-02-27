//
//  CalculateView.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 28..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

final class CalculateView: UIView {
    
    var goldLabel: UILabel = {
        var label = UILabel()
        label.text = "0"
        label.sizeToFit()
        return label
    }()
    
    var detailGoldLabel: UILabel = {
        var label = UILabel()
        label.text = "0골드"
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    private let devideLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(goldLabel)
        addSubview(detailGoldLabel)
        addSubview(devideLine)
        
        goldLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        detailGoldLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        devideLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


