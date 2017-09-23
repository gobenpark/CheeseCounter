//
//  EmptyView.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 5. 10..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class EmptyView: UIView{
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.text = "1:1문의를 주시면 관리자가 응답해드립니다."
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        backgroundColor = #colorLiteral(red: 0.9489366412, green: 0.9490727782, blue: 0.9489067197, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
