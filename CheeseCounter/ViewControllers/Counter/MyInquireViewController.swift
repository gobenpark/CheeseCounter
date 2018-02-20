//
//  MyInquireViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 26..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit

import DZNEmptyDataSet

class MyInquireViewController: UIViewController{
    
    var qnaList: [QnaListData.Data]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyInquireView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MyInquireView.ID)
        collectionView.register(MyInquireViewCell.self, forCellWithReuseIdentifier: MyInquireViewCell.ID)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 54, right: 0)
        collectionView.reloadEmptyDataSet()
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = collectionView
        self.view.backgroundColor = .white
        fetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetch()
    }
    
    func fetch(){
        CheeseService.getQnaList { (response) in
            switch response.result {
            case .success(let value):
                self.qnaList = value.data
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        }
    }
  @objc fileprivate dynamic func expandAction(_ sender: UIGestureRecognizer){
        
        guard let expand = qnaList?[sender.view?.tag ?? 0].isExpand else {return}
        if expand{
            qnaList?[sender.view?.tag ?? 0].isExpand = false
        }else {
            qnaList?[sender.view?.tag ?? 0].isExpand = true
        }
        self.collectionView.reloadSections(IndexSet(integer: sender.view?.tag ?? 0))
    }
}

extension MyInquireViewController: UICollectionViewDelegate{

}

extension MyInquireViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let count = qnaList?.count else {return 0}
        if count == 0 {
            self.collectionView.backgroundView = EmptyView()
        }else {
            self.collectionView.backgroundView = nil
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let expand = qnaList?[section].isExpand else {return 0}
        if expand {
            return 1
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyInquireViewCell.ID, for: indexPath) as! MyInquireViewCell
        cell.fetchData(data: qnaList?[indexPath.section])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView
        , viewForSupplementaryElementOfKind kind: String
        , at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyInquireView.ID, for: indexPath) as! MyInquireView
        view.fetchData(data: qnaList?[indexPath.section])
        view.tag = indexPath.section
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandAction(_:))))
        return view
    }
}

extension MyInquireViewController: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView
        , layout collectionViewLayout: UICollectionViewLayout
        , sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let content = qnaList?[indexPath.section].q_contents{
            let height = content.boundingRect(with: CGSize(width: 372-52, height: 1000)
              , attributes:[NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)]).height
            if let answer = qnaList?[indexPath.section].a_contents{
                let answerheight = answer.boundingRect(with: CGSize(width: 372-52, height: 1000)
                  , attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)]).height
                
                return CGSize(width: collectionView.frame.width, height: height+answerheight+150)
            } else {
                return CGSize(width: collectionView.frame.width, height: height + 100)
            }
        }
        
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView
        , layout collectionViewLayout: UICollectionViewLayout
        , referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

class MyInquireViewCell: UICollectionViewCell{
    
    static let ID = "MyInquireViewCell"
    
    let searchIcon: UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "icon_q@1x"))
        return imgView
    }()
    
    let answerIcon: UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "icon_a@1x"))
        return imgView
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let answerLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let answerDate: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .lightGray
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(commentLabel)
        contentView.addSubview(searchIcon)
        contentView.addSubview(answerIcon)
        contentView.addSubview(answerLabel)
        contentView.addSubview(answerDate)
        
        searchIcon.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(26)
            make.top.equalToSuperview().inset(16)
            make.height.equalTo(21)
            make.width.equalTo(21)
        }
        
        commentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(searchIcon.snp.right)
            make.top.equalTo(searchIcon)
            make.right.equalTo(self.snp.rightMargin).inset(26)
        }
        
        answerIcon.snp.makeConstraints { (make) in
            make.left.equalTo(searchIcon)
            make.height.equalTo(searchIcon.snp.height)
            make.width.equalTo(searchIcon.snp.width)
            make.top.equalTo(commentLabel.snp.bottom).offset(32)
        }
        
        answerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(answerIcon.snp.right)
            make.top.equalTo(answerIcon)
            make.right.equalToSuperview().inset(26)
        }
        
        answerDate.snp.makeConstraints { (make) in
            make.left.equalTo(answerLabel)
            make.top.equalTo(answerLabel.snp.bottom).offset(26)
        }
    }
    
    func fetchData(data:QnaListData.Data?){
        self.commentLabel.text = data?.q_contents ?? ""
        self.answerLabel.text = data?.a_contents ?? ""
        self.answerDate.text = (data?.a_created_date ?? "")
            .components(separatedBy: " ")[0]
            .replacingOccurrences(of: "-", with: ".")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyInquireView: UICollectionReusableView{
    
    static let ID = "MyInquireView"
    
    let dividLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    let completeLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(completeLabel)
        addSubview(dividLine)
        
        backgroundColor = .white
        
        dividLine.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(26)
            make.centerY.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.centerY.equalTo(titleLabel)
        }
        
        completeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(21)
            make.centerY.equalToSuperview()
        }
    }
    
    func fetchData(data:QnaListData.Data?){
        self.titleLabel.text = data?.q_title ?? ""
        self.dateLabel.text = (data?.a_created_date ?? "")
            .components(separatedBy: " ")[0]
            .replacingOccurrences(of: "-", with: ".")
        if let status = data?.q_status{
            if status == "ready"{
                self.completeLabel.text = "대기"
                self.completeLabel.textColor = .black
            }else {
                self.completeLabel.text = "완료"
                self.completeLabel.textColor = #colorLiteral(red: 1, green: 0.5535024405, blue: 0.3549469709, alpha: 1)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



