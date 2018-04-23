//
//  SpinWheelControl.swift
//  SpinWheelControl
//
//
//Trigonometry is used extensively in SpinWheel Control. Here is a quick refresher.
//Sine, Cosine and Tangent are each a ratio of sides of a right angled triangle
//Arc tangent (atan2) calculates the angles of a right triangle (tangent = Opposite / Adjacent)
//The sin is ratio of the length of the side that is opposite that angle to the length of the longest side of the triangle (the hypotenuse) (sin = Opposite / Hypotenuse)
//The cosine is (cosine = Adjacent / Hypotenuse)

import UIKit
import RxSwift
import RxCocoa
import Toaster


public typealias Degrees = CGFloat
public typealias Radians = CGFloat
typealias Velocity = CGFloat

public enum SpinDirection{
  case right
  case left
}

public enum SpinWheelStatus {
  case idle, decelerating, snapping
}

public enum SpinWheelDirection {
  case up, right, down, left
  
  var radiansValue: Radians {
    switch self {
    case .up:
      return Radians.pi / 2
    case .right:
      return 0
    case .down:
      return -(Radians.pi / 2)
    case .left:
      return Radians.pi
    }
  }
  
  var degreesValue: Degrees {
    switch self {
    case .up:
      return 90
    case .right:
      return 0
    case .down:
      return 270
    case .left:
      return 180
    }
  }
}

@IBDesignable
open class SpinWheelControl: UIControl {
  
  //MARK: Properties
  @IBInspectable var borderWidth: CGFloat = 0 {
    didSet {
      layer.borderWidth = borderWidth
    }
  }
  
  
  @IBInspectable var borderColor: UIColor? {
    didSet {
      layer.borderColor = borderColor?.cgColor
    }
  }
  
  
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
    }
  }
  
  
  @IBInspectable var snapOrientation: CGFloat = SpinWheelDirection.up.degreesValue {
    didSet {
      snappingPositionRadians = snapOrientation.toRadians
    }
  }
  
  let velocitySubject = PublishSubject<CGFloat>()
  
  @objc weak public var dataSource: SpinWheelControlDataSource?
  @objc public var delegate: SpinWheelControlDelegate?
  
  @objc static let kMinimumRadiansForSpin: Radians = 0.01
  
  /// 중앙으로부터 거리
  @objc static let kMinDistanceFromCenter: CGFloat = 30.0
  /// 최대 가속도
  @objc static let kMaxVelocity: Velocity = 30
  /// 감속 배율 0.98 설정 낮을수록 감속이 빠름
  @objc static let kDecelerationVelocityMultiplier: CGFloat = 0.99
  @objc static let kSpeedToSnap: CGFloat = 0.05
  @objc static let kSnapRadiansProximity: Radians = 0.001
  @objc static let kWedgeSnapVelocityMultiplier: CGFloat = 10.0
  @objc static let kZoomZoneThreshold = 1.5
  @objc static let kPreferredFramesPerSecond: Int = 60
  
  //A circle = 360 degrees = 2 * pi radians
  @objc let kCircleRadians: Radians = 2 * CGFloat.pi
  
  @objc public var spinWheelView: UIView!
  
  private var numberOfWedges: UInt!
  private var radiansPerWedge: CGFloat!
  
  private var globalRadians: CGFloat = 0
  
  @objc var decelerationDisplayLink: CADisplayLink? = nil
  @objc var snapDisplayLink: CADisplayLink? = nil
  
  var startTrackingTime: CFTimeInterval!
  var endTrackingTime: CFTimeInterval!
  
  var previousTouchRadians: Radians!
  var currentTouchRadians: Radians!
  var startTouchRadians: Radians!
  var currentlyDetectingTap: Bool!
  private(set) var spinDirection: SpinDirection!
  
  var currentStatus: SpinWheelStatus = .idle
  
  var currentDecelerationVelocity: Velocity!
  
  /// 시작시 고정방향 Radians.pi / 2
  @objc var snappingPositionRadians: Radians = SpinWheelDirection.up.radiansValue
  var snapDestinationRadians: Radians!
  var snapIncrementRadians: Radians!
  
  @objc public var selectedIndex: Int = 0
  
  var previousVelocity: Velocity = 0
  
  
  //MARK: Computed Properties
  @objc var spinWheelCenter: CGPoint {
    return convert(center, from: superview)
  }
  
  @objc var diameter: CGFloat {
    return min(self.spinWheelView.frame.width, self.spinWheelView.frame.height)
  }
  
  @objc var degreesPerWedge: Degrees {
    return 360 / CGFloat(numberOfWedges)
  }
  
  //The radius of the spin wheel's circle
  @objc var radius: CGFloat {
    return diameter / 2
  }
  
  //How far the wheel is turned from its default position
  @objc var currentRadians: Radians {
    return atan2(self.spinWheelView.transform.b, self.spinWheelView.transform.a)
  }
  
  //How many radians there are to snapDestinationRadians
  @objc var radiansToDestinationSlice: Radians {
    return snapDestinationRadians - currentRadians
  }
  
  //The velocity of the spinwheel
  @objc var velocity: Velocity {
    var computedVelocity: Velocity = 0
    
    //If the wheel was actually spun, calculate the new velocity
    if endTrackingTime != startTrackingTime &&
      abs(previousTouchRadians - currentTouchRadians) >= SpinWheelControl.kMinimumRadiansForSpin {
      computedVelocity = (previousTouchRadians - currentTouchRadians) / CGFloat(endTrackingTime - startTrackingTime)
    }
    
    //If the velocity is beyond the maximum allowed velocity, throttle it
    if computedVelocity > SpinWheelControl.kMaxVelocity {
      repeat {
        computedVelocity = Velocity(Int(arc4random_uniform(11)) + 25)
      }
        while previousVelocity == computedVelocity
      
      previousVelocity = computedVelocity
    }
    else if computedVelocity < -SpinWheelControl.kMaxVelocity {
      repeat {
        computedVelocity = Velocity(Int(arc4random_uniform(11)) - 35)
      }
        while previousVelocity == computedVelocity
      
      previousVelocity = computedVelocity
    }
    return computedVelocity
  }
  
  //MARK: Initialization Methods
  override public init(frame: CGRect) {
    super.init(frame: frame)
    self.drawWheel()
  }
  
  public init(frame: CGRect, snapOrientation: SpinWheelDirection) {
    super.init(frame: frame)
    self.drawWheel()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.drawWheel()
  }
  
  
  func reloadRotate(){
    self.spinWheelView.transform = CGAffineTransform(rotationAngle: 0)
    currentDecelerationVelocity = 0
    setNeedsLayout()
  }
  
  //MARK: Methods
  //Clear the SpinWheelControl from the screen
  @objc public func clear() {
    
    for subview in spinWheelView.subviews {
      subview.removeFromSuperview()
    }
    guard let sublayers = spinWheelView.layer.sublayers else {
      return
    }
    for sublayer in sublayers {
      sublayer.removeFromSuperlayer()
    }
  }
  
  //Draw the spinWheelView
  @objc public func drawWheel() {
    
    
    spinWheelView = UIView(frame: self.bounds)
    
    guard self.dataSource?.numberOfWedgesInSpinWheel(spinWheel: self) != nil else {
      return
    }
    numberOfWedges = self.dataSource?.numberOfWedgesInSpinWheel(spinWheel: self)
    
    guard numberOfWedges >= 2 else {
      return
    }
    
    radiansPerWedge = kCircleRadians / CGFloat(numberOfWedges)
    
    guard let source = self.dataSource else {
      return
    }
    
    for wedgeNumber in 0..<numberOfWedges {
      let wedge: SpinWheelWedge = source.wedgeForSliceAtIndex(index: wedgeNumber)
      
      //Wedge shape
      wedge.shape.configureWedgeShape(index: wedgeNumber, radius: radius, position: spinWheelCenter, degreesPerWedge: degreesPerWedge)
      wedge.layer.addSublayer(wedge.shape)
      
      //Wedge Image
      wedge.image.configureWedgeImage(index: Int(wedgeNumber), position: spinWheelCenter, radiansPerWedge: radiansPerWedge)
      wedge.addSubview(wedge.image)
      
      wedge.point.configureWedgeImage(index: Int(wedgeNumber), position: spinWheelCenter, radiansPerWedge: radiansPerWedge, totalCount: numberOfWedges)
      wedge.addSubview(wedge.point)
      
      //Add the shape and label to the spinWheelView
      spinWheelView.addSubview(wedge)
    }
    
    self.spinWheelView.isUserInteractionEnabled = false
    //    self.spinWheelView.transform = CGAffineTransform(rotationAngle: -(snappingPositionRadians) - (radiansPerWedge / 2))
    self.addSubview(self.spinWheelView)
  }
  
  //When the SpinWheelControl ends rotation, trigger the UIControl's valueChanged to reflect the newly selected value.
  @objc func didEndRotationOnWedgeAtIndex(index: UInt) {
    selectedIndex = Int(index)
    delegate?.spinWheelDidEndDecelerating?(spinWheel: self)
    self.sendActions(for: .valueChanged)
  }
  
  /// 유저 터치 이벤트가 시작될 때
  override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    switch currentStatus {
    case SpinWheelStatus.idle:
      currentlyDetectingTap = true
    case SpinWheelStatus.decelerating:
      endDeceleration()
      endSnap()
    case SpinWheelStatus.snapping:
      endSnap()
    }
    
    let touchPoint: CGPoint = touch.location(in: self)
    
    if distanceFromCenter(point: touchPoint) < SpinWheelControl.kMinDistanceFromCenter {
      return false
    }
    
    startTrackingTime = CACurrentMediaTime()
    endTrackingTime = startTrackingTime
    startTouchRadians = radiansForTouch(touch: touch)
    currentTouchRadians = startTouchRadians
    previousTouchRadians = startTouchRadians
    
    return true
  }
  
  /// 유저가 드레깅 중일때
  override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    currentlyDetectingTap = false
    
    startTrackingTime = endTrackingTime
    endTrackingTime = CACurrentMediaTime()
    
    let touchPoint: CGPoint = touch.location(in: self)
    
    let distanceFromCenterOfSpinWheel: CGFloat = distanceFromCenter(point: touchPoint)
    
    if distanceFromCenterOfSpinWheel < SpinWheelControl.kMinDistanceFromCenter {
      return true
    }
    
    // 현재 저장된 radians를 previous에 저장 후 터치 좌표 받아 current에 저장
    previousTouchRadians = currentTouchRadians
    currentTouchRadians = radiansForTouch(touch: touch)
    
    if (sign(startTouchRadians) != sign(currentTouchRadians)) {
      if (abs(abs(startTouchRadians) - abs(currentTouchRadians)) > 0.7) {
        self.reloadRotate()
      }
    } else {
      if (abs(abs(startTouchRadians) - abs(currentTouchRadians)) > 1.1) {
        self.reloadRotate()
      }
    }
    
//    log.info("startTouchRadians : \(startTouchRadians), currentTouchRadians : \(currentTouchRadians)")
    
    var touchRadiansDifference: Radians = currentTouchRadians - previousTouchRadians
  
    if touchRadiansDifference > 5 && touchRadiansDifference < -5{
      touchRadiansDifference = currentTouchRadians + previousTouchRadians
    }
    
    self.spinWheelView.transform = self.spinWheelView.transform.rotated(by: touchRadiansDifference)
    delegate?.spinWheelDidRotateByRadians?(radians: touchRadiansDifference)

    endSnap()
    return true
  }
  
  //유저의 터치 가 끝날때
  override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    let tapCount = touch?.tapCount != nil ? (touch?.tapCount)! : 0
    //TODO: Implement tap to move to wedge
    //If the user just tapped, move to that wedge
    
    if currentStatus == .idle &&
      tapCount > 0 &&
      currentlyDetectingTap {}
      //Else decelerate
    else {
      beginDeceleration()
    }
  }
  
  //터치 이벤트 이후 감속이 시작될때
  @objc func beginDeceleration() {
    
    currentDecelerationVelocity = velocity
    
    if velocity < 0{
      spinDirection = SpinDirection.right
    }else{
      spinDirection = SpinDirection.left
    }
    
    let touchRadiansDifference: Radians = currentTouchRadians - previousTouchRadians
    
    if abs(touchRadiansDifference) > CGFloat.pi{
      currentDecelerationVelocity = -currentDecelerationVelocity
    }
    
    velocitySubject.onNext(currentDecelerationVelocity)
    
    delegate?.spinStart?(velocity: currentDecelerationVelocity)
    //If the wheel was spun, begin deceleration
    if currentDecelerationVelocity != 0 {
      currentStatus = .decelerating
      
      decelerationDisplayLink?.invalidate()
      decelerationDisplayLink = CADisplayLink(target: self, selector: #selector(SpinWheelControl.decelerationStep))
      if #available(iOS 10.0, *) {
        decelerationDisplayLink?.preferredFramesPerSecond = SpinWheelControl.kPreferredFramesPerSecond
      } else {
        // TODO: Fallback on earlier versions
        decelerationDisplayLink?.preferredFramesPerSecond = SpinWheelControl.kPreferredFramesPerSecond
      }
      decelerationDisplayLink?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
      //Else snap to the nearest wedge.  No deceleration necessary.
    else {
      snapToNearestWedge()
    }
  }
  
  
  //Deceleration step run for each frame of decelerationDisplayLink
  /// display link 프레임 스텝 당 감속도 계산
  @objc func decelerationStep() {
    
    let newVelocity: Velocity = currentDecelerationVelocity * SpinWheelControl.kDecelerationVelocityMultiplier
    let radiansToRotate: Radians = currentDecelerationVelocity / CGFloat(SpinWheelControl.kPreferredFramesPerSecond)
    
    //If the spinwheel has slowed down to under the minimum speed, end the deceleration
    if newVelocity <= SpinWheelControl.kSpeedToSnap &&
      newVelocity >= -SpinWheelControl.kSpeedToSnap {
      endDeceleration()
    }
      //else continue decelerating the SpinWheel
    else {
      currentDecelerationVelocity = newVelocity
      self.spinWheelView.transform = self.spinWheelView.transform.rotated(by: -radiansToRotate)
      delegate?.spinWheelDidRotateByRadians?(radians: -radiansToRotate)
    }
    
    endSnap()
  }
  
  //정지 될때
  @objc func endDeceleration() {
    decelerationDisplayLink?.invalidate()
    self.sendActions(for: UIControlEvents.editingDidEnd)
    snapToNearestWedge()
  }
  
  //Snap to the nearest wedge
  @objc func snapToNearestWedge() {
    currentStatus = .snapping
    
    let nearestWedge: Int = Int(round(((currentRadians + (radiansPerWedge / 2)) + snappingPositionRadians) / radiansPerWedge))
    selectWedgeAtIndexOffset(index: nearestWedge, animated: true)
    endSnap()
  }
  
  @objc func snapStep() {
    let difference: Radians = atan2(sin(radiansToDestinationSlice), cos(radiansToDestinationSlice))
    //If the spin wheel is turned close enough to the destination it is snapping to, end snapping
    if abs(difference) <= SpinWheelControl.kSnapRadiansProximity {
      endSnap()
    }
      //else continue snapping to the nearest wedge
    else {
      let newPositionRadians: Radians = currentRadians + snapIncrementRadians
      self.spinWheelView.transform = CGAffineTransform(rotationAngle: newPositionRadians)
      
      delegate?.spinWheelDidRotateByRadians?(radians: newPositionRadians)
    }
  }
  
  //End snapping
  @objc func endSnap() {
    //snappingPositionRadians is the default snapping position (in this case, up)
    //currentRadians in this case is where in the wheel it is currently snapped
    //Distance of zero wedge from the default snap position (up)
    var indexSnapped: Radians = (-(snappingPositionRadians) - currentRadians - (radiansPerWedge / 2))
    
    //Number of wedges from the zero wedge to the default snap position (up)
    indexSnapped = indexSnapped / radiansPerWedge + CGFloat(numberOfWedges)
    
    indexSnapped = indexSnapped.rounded(FloatingPointRoundingRule.toNearestOrAwayFromZero)
    indexSnapped = indexSnapped.truncatingRemainder(dividingBy: CGFloat(numberOfWedges))
    
    didEndRotationOnWedgeAtIndex(index: UInt(indexSnapped))
    
    snapDisplayLink?.invalidate()
    currentStatus = .idle
  }
  
  
  //Return the radians at the touch point. Return values range from -pi to pi
  @objc func radiansForTouch(touch: UITouch) -> Radians {
    let touchPoint: CGPoint = touch.location(in: self)
    let dx: CGFloat = touchPoint.x - self.spinWheelView.center.x
    let dy: CGFloat = touchPoint.y - self.spinWheelView.center.y
    return atan2(dy, dx)
  }
  
  
  //Select a wedge with an index offset relative to 0 position. May be positive or negative.
  @objc func selectWedgeAtIndexOffset(index: Int, animated: Bool) {
    snapDestinationRadians = -(snappingPositionRadians) + (CGFloat(index) * radiansPerWedge) - (radiansPerWedge / 2)
    
    if currentRadians != snapDestinationRadians {
      snapIncrementRadians = radiansToDestinationSlice / SpinWheelControl.kWedgeSnapVelocityMultiplier
    }
    else {
      return
    }
    
    currentStatus = .snapping
    
    snapDisplayLink?.invalidate()
    snapDisplayLink = CADisplayLink(target: self, selector: #selector(snapStep))
    if #available(iOS 10.0, *) {
      snapDisplayLink?.preferredFramesPerSecond = SpinWheelControl.kPreferredFramesPerSecond
    } else {
      // Fallback on earlier versions
    }
    snapDisplayLink?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
  }
  
  
  //중심 점으로부터 거리
  @objc func distanceFromCenter(point: CGPoint) -> CGFloat {
    let dx: CGFloat = point.x - spinWheelCenter.x
    let dy: CGFloat = point.y - spinWheelCenter.y
    return sqrt(dx * dx + dy * dy)
  }
  
  //Clear all views and redraw the spin wheel
  @objc public func reloadData() {
    clear()
    drawWheel()
  }
  
  func sign(_ rad: Radians) -> Int {
    if (rad > 0) {
      return 1
    } else {
      return -1
    }
  }
}







