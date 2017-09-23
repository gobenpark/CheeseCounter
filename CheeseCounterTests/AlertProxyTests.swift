//
//  AlertProxyTests.swift
//  CheeseCounterTests
//
//  Created by xiilab on 2017. 9. 20..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import XCTest
import Quick
import Nimble


class AlertProxyTests: QuickSpec {
  override func spec() {
    describe("Input Test") {
      it("is qna"){
        let qna = "qna"
        expect(qna).to(equal("qna"))
      }
    }
  }
}
