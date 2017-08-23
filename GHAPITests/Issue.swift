//
//  Issue.swift
//  GHAPI
//
//  Created by Pi on 21/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
import PaversFRP
import PaversArgo
@testable import GHAPI

internal final class IssueTests: XCTestCase {

  fileprivate var json: JSON? = GHAPITestsHelper.jsonObject(named: "Issue")

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
    let decodePayload = Issue.decode(json)
    guard
      let payload = decodePayload.value
      else { XCTAssert(false, "payload cannot be constructed"); return }
    XCTAssertEqual(payload.id, 47809604)
    let jsonStr = payload.toJSONString()
    XCTAssertNotNil(jsonStr)
  }
}
