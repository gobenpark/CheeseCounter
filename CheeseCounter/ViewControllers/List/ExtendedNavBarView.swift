import Foundation
import BetterSegmentedControl

class ExtendedNavBarView: UIView {
  
  
  var titles: [String] = []{
    didSet{
      self.segmentedControl.titles = titles
    }
  }
  
  lazy var segmentedControl: BetterSegmentedControl = {
    let sc = BetterSegmentedControl(frame: .zero, titles: [], index: 0, options: [BetterSegmentedControlOption.backgroundColor(.white),.titleColor(.lightGray)])

    sc.layer.borderWidth = 0.5
    sc.layer.borderColor = UIColor.lightGray.cgColor
    sc.titleFont = UIFont.CheeseFontMedium(size: 14)
    return sc
  }()
  
  
  /**
   *  Called when the view is about to be displayed.  May be called more than
   *  once.
   */
  override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)
    addSubview(segmentedControl)
    
    
    //        // Use the layer shadow to draw a one pixel hairline under this view.
    //        layer.shadowOffset = CGSize(width: 0, height: CGFloat(1) / UIScreen.main.scale)
    //        layer.shadowRadius = 0
    //
    //        // UINavigationBar's hairline is adaptive, its properties change with
    //        // the contents it overlies.  You may need to experiment with these
    //        // values to best match your content.
    //        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
    //        layer.shadowOpacity = 0.25
    let bottomView = UIView()
    bottomView.backgroundColor = #colorLiteral(red: 0.9978943467, green: 0.8484466672, blue: 0.1216805503, alpha: 1)
    self.addSubview(bottomView)
    
    
    bottomView.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(2)
    }
    
    segmentedControl.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(30)
      make.centerY.equalToSuperview()
      make.height.equalToSuperview().dividedBy(2)
      make.right.equalToSuperview().inset(30)
    }
  }
}
