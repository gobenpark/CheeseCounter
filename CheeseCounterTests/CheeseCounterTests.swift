//
//  CheeseCounterTests.swift
//  CheeseCounterTests
//
//  Created by xiilab on 2017. 2. 27..
//  Copyright © 2017년 xiilab. All rights reserved.
//


import Quick
import Nimble
import Moya

@testable import CheeseCounter


class CheeseCounterTests: QuickSpec {
  
  override func spec(){
    
    
    it("is friendly"){
      expect(1 + 1).to(equal(30))
    }
  }
}
