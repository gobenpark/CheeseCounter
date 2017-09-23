//
//  QuestionChoiceGender.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 24..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class QuestionSelectGenderVC: UIViewController {
    
    var didTap:((String) -> ())?
    
    var gender:String?{
        didSet{
            if gender == "male,female"{
                maleImageButton.isSelected = true
                femaleImageButton.isSelected = true
            } else if gender == "male"{
                maleImageButton.isSelected = true
                femaleImageButton.isSelected = false
            } else {
                maleImageButton.isSelected = false
                femaleImageButton.isSelected = true 
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.CheeseFontBold(size: 16)
        label.text = "성별 (중복 가능)"
        return label
    }()
    
    lazy var maleImageButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "male_nomal@1x"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "male_select@1x"), for: .selected)
        button.addTarget(self, action: #selector(maleGenderSelect(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var femaleImageButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "female_nomal@1x"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "female_select@1x"), for: .selected)
        button.addTarget(self, action: #selector(femaleGenderSelect(_:)), for: .touchUpInside)
        return button
    }()
    
    
    lazy var commitButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_select@1x"), for: .normal)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        view.backgroundColor = UIColor(red: 254/255, green: 220/255, blue: 25/255, alpha: 0.8)
    }
    
    func setUp(){
        
        view.addSubview(titleLabel)
        view.addSubview(maleImageButton)
        view.addSubview(femaleImageButton)
        view.addSubview(commitButton)
        addConstraint()
        self.view.backgroundColor = #colorLiteral(red: 0.9983282685, green: 0.5117852092, blue: 0.2339783907, alpha: 1)
    }
    
    fileprivate func addConstraint(){
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin).offset(105)
            make.centerX.equalToSuperview()
        }
        
        maleImageButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().inset(-90)
            make.height.equalTo(170)
            make.width.equalTo(170)
        }
        
        femaleImageButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().inset(90)
            make.height.equalTo(170)
            make.width.equalTo(170)
        }
        
        commitButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(37)
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.right.equalToSuperview().inset(20)
        }
    }
    
    fileprivate dynamic func maleGenderSelect(_ sender: UIButton){
        sender.isSelected = sender.isSelected ? false : true
    }
    
    fileprivate dynamic func femaleGenderSelect(_ sender: UIButton){
        sender.isSelected = sender.isSelected ? false : true
    }
    
    fileprivate dynamic func buttonAction(_ sender: UIButton){
        var genderString: String = ""
        
        guard let tap = didTap else {return}
        
        if maleImageButton.isSelected && femaleImageButton.isSelected{
            genderString = "male,female"
        } else if !maleImageButton.isSelected && femaleImageButton.isSelected{
            genderString = "female"
        } else if maleImageButton.isSelected && !femaleImageButton.isSelected{
            genderString = "male"
        } else {
            alertView()
            return
        }
        tap(genderString)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func alertView(){
        let alertController = UIAlertController(title: "알림", message: "성별을 입력해주세요", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
