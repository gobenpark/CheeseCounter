//
//  CycleViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 10. 18..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit
import SpriteKit


class CycleViewController: UIViewController{
  
  
  
  let wheelNode: SKShapeNode = {
    let node = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
    node.position = CGPoint(x: 250, y: 200)
    node.name = "spinner"
    node.strokeColor = SKColor.blue
    
    node.fillColor = SKColor.red
    node.physicsBody = SKPhysicsBody(circleOfRadius: 4)
//    node.physicsBody?.isDynamic = true
    node.physicsBody?.affectedByGravity = false //중력
    node.physicsBody?.allowsRotation = true // 충돌에 의해 물체가 회전
    node.physicsBody?.angularDamping = 0.5
    
    return node
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    let skView = SKView(frame: view.bounds)
    self.view = skView
    let scene = SKScene(size: view.bounds.size)
    scene.addChild(wheelNode)
    
    
    
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.ignoresSiblingOrder = true
    skView.presentScene(scene)
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.wheelNode.physicsBody?.applyAngularImpulse(1)
  }
}
