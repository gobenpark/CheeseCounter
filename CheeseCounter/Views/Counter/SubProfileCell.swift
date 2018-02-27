//
//  SubProfileCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 21..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class SubProfileCell: UITableViewCell{
    
    static let ID = "SubProfileCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.CheeseFontMedium(size: 16)
        label.textColor = .lightGray
        label.sizeToFit()
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = UIFont.CheeseFontMedium(size: 18)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        
        self.selectionStyle = .none
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.leftMargin)
            make.centerY.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    func fetchProfileData(data:UserResult.Data?){
        guard let data = data else { return }
        switch subTitleLabel.tag{
        case 0:
            self.subTitleLabel.text = data.nickname ?? ""
        case 1:
            switch (data.gender ?? ""){
            case "male":
                self.subTitleLabel.text = "남"
            case "female":
                self.subTitleLabel.text = "여"
            default:
                break
            }
        case 2:
            self.subTitleLabel.text = data.age ?? ""
        case 3:
            self.subTitleLabel.text = "\(data.addr1 ?? "") \(data.addr2 ?? "")"
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
