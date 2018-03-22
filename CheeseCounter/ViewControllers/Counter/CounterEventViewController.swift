


import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet

class CounterEventViewController: UIViewController{
  
  var events:[EventModel.Data] = []
  var isEmptyViews:Bool = true
  var id: String?
  private let disposeBag = DisposeBag()
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .white
    collectionView.register(EventViewCell.self, forCellWithReuseIdentifier: String(describing: EventViewCell.self))
    collectionView.register(
      EventView.self
      , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
      , withReuseIdentifier: String(describing: EventView.self)
    )
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view = collectionView
    fetch()
  }
  
  func fetch(){
    CheeseService.provider
      .request(.getEventAllList)
      .filter(statusCode: 200)
      .map(EventModel.self)
      .do(onSuccess: {[unowned self] (model) in
        self.events = model.result.data
        self.collectionView.reloadData()
      })
      .asObservable()
      .bind(onNext: expandPage)
      .disposed(by: disposeBag)
  }
  
  func expandPage(from model: EventModel){
    guard let id = id else {return}
    for i in 0..<events.count{
      if events[i].id == id{
        events[i].isExpand = true
        self.collectionView.reloadItems(at: [IndexPath(row: 0, section: i)])
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: i), at: .top, animated: true)
      }
    }
  }
  
  @objc fileprivate dynamic func expandAction(_ sender: UIGestureRecognizer){
    events[sender.view?.tag ?? 0].isExpand =
      events[sender.view?.tag ?? 0].isExpand ? false : true
    self.collectionView.reloadSections(IndexSet(integer: sender.view?.tag ?? 0))
  }
}

extension CounterEventViewController: UICollectionViewDelegate{
}

extension CounterEventViewController: UICollectionViewDataSource{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if events[section].isExpand{
      return 1
    }else {
      return 0
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    if events.count == 0 {
      let view = EmptyView()
      view.titleLabel.text = "새로운 이벤트가 준비 중입니다."
      self.collectionView.backgroundView = view
    }else {
      self.collectionView.backgroundView = nil
    }
    return events.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: String(describing: EventViewCell.self)
      , for: indexPath) as! EventViewCell
    cell.fetch(data: events[indexPath.section])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView
    , viewForSupplementaryElementOfKind kind: String
    , at indexPath: IndexPath) -> UICollectionReusableView {
    
    let view = collectionView
      .dequeueReusableSupplementaryView(
        ofKind: kind
        , withReuseIdentifier: String(describing: EventView.self)
        , for: indexPath) as! EventView
    view.fetch(data: events[indexPath.section])
    view.tag = indexPath.section
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandAction(_:))))
    return view
  }
  
  func collectionView(_ collectionView: UICollectionView
    , layout collectionViewLayout: UICollectionViewLayout
    , referenceSizeForHeaderInSection section: Int) -> CGSize {
    
    let size = events[section].title.boundingRect(with: CGSize(width: 374-57, height: 100)
      , attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)])
    
    return CGSize(width: collectionView.frame.width, height: size.height+30)
  }
}

extension CounterEventViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView
    , layout collectionViewLayout: UICollectionViewLayout
    , sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let size = events[indexPath.section].contents.boundingRect(with: CGSize(width: 374-42, height: 1000)
      , attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)])
    return CGSize(width: collectionView.frame.width, height: size.height+481)
  }
}

class EventViewCell: UICollectionViewCell{
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
  let commentLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.numberOfLines = 0
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()
  
  let dateLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.font = UIFont.systemFont(ofSize: 11)
    label.textColor = .lightGray
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(commentLabel)
    contentView.addSubview(dateLabel)
    contentView.addSubview(imageView)
    
    imageView.snp.makeConstraints { (make) in
      make.left.right.top.equalToSuperview()
      make.height.equalTo(400)
    }
    
    commentLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(21)
      make.top.equalTo(imageView.snp.bottom).offset(10)
      make.right.equalToSuperview().inset(27)
    }
    
    dateLabel.snp.makeConstraints { (make) in
      make.left.equalTo(commentLabel)
      make.top.equalTo(commentLabel.snp.bottom).offset(27)
    }
  }
  
  func fetch(data: EventModel.Data){
    self.commentLabel.text = data.contents
    self.dateLabel.text = data.start_date
      .components(separatedBy: " ")[0]
      .replacingOccurrences(of: "-", with: ".")
    imageView.kf.setImage(with: URL(string: (data.img_url ?? String()).getUrlWithEncoding()))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class EventView: UICollectionReusableView{
  
  let dividLine: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.sizeToFit()
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 2
    return label
  }()
  
  let arrowButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "arrow_open@1x"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "arrow_close@1x"), for: .selected)
    button.isUserInteractionEnabled = false
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleLabel)
    addSubview(arrowButton)
    addSubview(dividLine)
    
    dividLine.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.top.equalToSuperview()
      make.height.equalTo(0.5)
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(21)
      make.centerY.equalToSuperview()
    }
    
    arrowButton.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(21)
      make.centerY.equalToSuperview()
    }
  }
  
  func fetch(data: EventModel.Data){
    let date = data.start_date
      .components(separatedBy: " ")[0]
      .replacingOccurrences(of: "-", with: ".")
    let attribute = NSMutableAttributedString(string: data.title
      , attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)])
    attribute.append(NSAttributedString(string: " "+date
      , attributes: [
        NSAttributedStringKey.font:UIFont.systemFont(ofSize: 11)
        ,NSAttributedStringKey.foregroundColor:UIColor.lightGray
      ]))
    titleLabel.attributedText = attribute
    
    if (data.isExpand){
      arrowButton.isSelected = true
    }else {
      arrowButton.isSelected = false
    }
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

