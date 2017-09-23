//
//  ListTableViewCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 6..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell
{
   
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.CheeseFontMedium(size: 18)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    let hartImageView: UIImageView = {
        let img = UIImageView(image: #imageLiteral(resourceName: "result_like_big_select@1x"))
        return img
    }()
    
    let hartLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.text = "200"
        label.textColor = #colorLiteral(red: 0.9983282685, green: 0.5117852092, blue: 0.2339783907, alpha: 1)
        return label
    }()
    
    let deadLineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.sizeToFit()
        return label
    }()
    let answerNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.sizeToFit()
        return label
    }()
    
    let reAnswerLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    let personIcon: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icon_person@1x"))
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(hartImageView)
        self.contentView.addSubview(personIcon)
        self.contentView.addSubview(hartLabel)
        self.contentView.addSubview(deadLineLabel)
        self.contentView.addSubview(answerNumberLabel)
        self.contentView.addSubview(reAnswerLabel)
        self.selectionStyle = .none
        snapkit()
    }
    
    func snapkit(){
        
        hartImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.leftMargin)
            make.top.equalTo(self.snp.topMargin)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        hartLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(hartImageView)
            make.left.equalTo(hartImageView.snp.right).offset(10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.centerY).inset(-10)
            make.left.equalTo(self.snp.leftMargin)
            make.right.equalToSuperview().inset(40)
        }
        
        personIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.leftMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        
        answerNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(personIcon.snp.right).offset(10)
            make.centerY.equalTo(personIcon)
        }
        
        self.reAnswerLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottomMargin)
            make.right.equalTo(self.snp.rightMargin)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

