//
//  Branch.swift
//  GHAPI
//
//  Created by Pi on 20/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
import PaversFRP
import PaversArgo
@testable import GHAPI

internal final class BranchTests: XCTestCase {

  fileprivate var json: JSON? = GHAPITestsHelper.jsonObject(named: "Branch")


  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testPayloadConstruction() {
    guard
      let json = self.json
      else { XCTAssert(false, "Json must not be nil"); return }
    let decodePayload = Branch.decode(json)
    guard
      let payload = decodePayload.value
      else { XCTAssert(false, "payload cannot be constructed"); return }
    XCTAssertEqual(payload.name, "swift-3.0-branch")
    let jsonStr = payload.toJSONString()
    XCTAssertNotNil(jsonStr)
  }
}
