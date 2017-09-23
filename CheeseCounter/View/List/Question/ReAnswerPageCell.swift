//
//  ReAnswerPageCell.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 8..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import SwiftyJSON
import Alamofire



class ReAnswerPageCell: UICollectionViewCell
{
    
    private let imageSize = 40
    private var user: KOUser?
    
    let dividedLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 266, green: 231, blue: 221)
        return view
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let answerTextView: UITextView = {
        let textView = UITextView()
        textView.text = "이처럼 아름다운 사람이 새끼가 주변에도\n 있었으면 좋겠네요."
        textView.textColor = .white
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(dividedLine)
        addSubview(profileImage)
        addSubview(answerTextView)
        addConstraint()
        profileImageUploading()
    }
    
    func profileImageUploading(){
        KOSessionTask.meTask { [weak self](user, error) in
            if error == nil {
                self?.user = user as? KOUser
                if let url = self?.user?.property(forKey: "profile_image") as? String{
                    Alamofire.request(url).responseData(completionHandler: {[weak self] (data) in
                        if data != nil {
                            self?.profileImage.image = UIImage(data:data.data!)
                        }
                    })
                }
            }
        }

    }
    
    
    func addConstraint(){
        
        dividedLine.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(50)
            make.right.equalToSuperview().inset(25)
            make.height.equalTo(1)
        }
        
        profileImage.snp.makeConstraints { (make) in
            make.height.equalTo(imageSize)
            make.width.equalTo(imageSize)
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        
        answerTextView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalTo(self.profileImage.snp.right)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
