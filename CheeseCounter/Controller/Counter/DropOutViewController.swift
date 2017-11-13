//
//  DropOutViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 3. 14..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

class DropOutViewController: UIViewController
{
    
    let dropoutLabel: UILabel = {
        let label = UILabel()
        label.text = "회원 탈퇴시 삭제되는 정보"
        label.sizeToFit()
        return label
    }()
    
    let detaildDropoutLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "- 내가 만든 질문과 응답, 댓글 정보 이외 회원님이 설정한 모든정보"
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.CheeseFontMedium(size: 16)
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.sizeToFit()
        return label
    }()
    
    lazy var dropoutButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "btn_gradation@1x"), for: .selected)
        button.setBackgroundImage(#imageLiteral(resourceName: "txt_box_2_nomal@1x"), for: .normal)
        button.setTitle("탈퇴요청하기", for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(dropAction(_:)), for: .touchUpInside)
        button.tag = 0
        return button
    }()
    
    lazy var agreeButton: UIButton = {
       let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "checkbox_leave_off@1x"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "checkbox_leave_on@1x"), for: .selected)
        button.addTarget(self, action: #selector(checkBoxAction(_:)), for: .touchUpInside)
        return button
    }()
    
    let agreeLabel: UILabel = {
        let label = UILabel()
        label.text = "탈퇴 후 삭제된 정보는 복구할 수 없습니다.\n위의 사항을 확인하였으며, 동의합니다."
        label.numberOfLines = 2
        label.sizeToFit()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(dropoutLabel)
        self.view.addSubview(detaildDropoutLabel)
        self.view.addSubview(dropoutButton)
        self.view.addSubview(agreeButton)
        self.view.addSubview(agreeLabel)
        addConstraint()
    }
    
    func addConstraint(){
        
        dropoutLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(25)
            make.left.equalToSuperview().inset(25)
        }
        
        detaildDropoutLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dropoutLabel.snp.bottom).offset(20)
            make.left.equalTo(dropoutLabel)
            make.right.equalToSuperview().inset(25)
        }
        
        agreeButton.snp.makeConstraints { (make) in
            make.top.equalTo(detaildDropoutLabel.snp.bottom).offset(30)
            make.left.equalTo(detaildDropoutLabel)
        }
        
        agreeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(agreeButton.snp.right).offset(20)
            make.top.equalTo(agreeButton)
            make.right.equalToSuperview().inset(25)
        }
        
        dropoutButton.snp.makeConstraints { (make) in
            make.top.equalTo(agreeLabel.snp.bottom).offset(25)
            make.left.equalToSuperview().inset(25)
            make.right.equalToSuperview().inset(25)
            make.height.equalTo(50)
        }
    }
    
  @objc fileprivate dynamic func checkBoxAction(_ sender: UIButton){
        sender.isSelected = sender.isSelected ? false : true
        
        if sender.isSelected{
            dropoutButton.isEnabled = true
            dropoutButton.isSelected = true
        }else {
            dropoutButton.isEnabled = false
            dropoutButton.isSelected = false
        }
    }
    
  @objc func dropAction(_ button: UIButton){
        
        let alertVC = UIAlertController(title: "탈퇴", message: "회원 탈퇴시, 보유 치즈(포인트),\n골드 모두 삭제되며, 이후 환급\n및\n환불되지 않습니다. 이미 등록한\n질문과 댓글은 삭제되지 않습니다.\n정말 탈퇴 하시겠습니까?", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "예", style: .destructive, handler: { (Action) in
            CheeseService.insertSecession({ (code) in
                self.navigationController?.popViewController(animated: true)
            })
        })
        let alertActionFalse = UIAlertAction(title: "아니오", style: .default,handler: { (_) in
        
        })
        
        alertVC.addAction(alertAction)
        alertVC.addAction(alertActionFalse)
        
        self.present(alertVC, animated: true, completion: nil)
    }
}
