//
//  SelectTagViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 24..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class SelectTagViewCell: UITableViewCell {
    
    static let ID = "SelectTagViewCell"
    
    var tapSwitch: ((Bool) -> Void)?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "타겟"
        label.font = UIFont.CheeseFontMedium(size: 15)
        label.sizeToFit()
        return label
    }()
    
    lazy var targetSwitch: UISwitch = {
        let ts = UISwitch()
        ts.addTarget(self, action: #selector(changeAction(_:)), for: .valueChanged)
        ts.onTintColor = #colorLiteral(red: 1, green: 0.848323524, blue: 0.005472274031, alpha: 1)
        return ts
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(){
        
        addSubview(titleLabel)
        addSubview(targetSwitch)
        
        self.backgroundColor = .white
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).inset(25)
            make.centerY.equalToSuperview()
        }
        
        targetSwitch.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.rightMargin)
            make.centerY.equalToSuperview()
        }
        
    }
    func changeAction(_ sender: UISwitch){
        guard let tap = tapSwitch else {return}
        tap(sender.isOn)
    }
}
