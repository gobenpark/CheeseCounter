//
//  AreaCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 21..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class AreaCell: UITableViewCell {
    
    let diviedView: UIView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        addSubview(diviedView)
        
        self.selectionStyle = .none
        self.textLabel?.textAlignment = .center
        
        diviedView.layer.cornerRadius = 10
        diviedView.layer.borderWidth = 1
        diviedView.layer.masksToBounds = true 
        
        diviedView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
