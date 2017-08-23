//
//  User.swift
//  GHAPI
//
//  Created by Pi on 11/04/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
import PaversFRP
import PaversArgo
@testable import GHAPI

internal final class UserTests: XCTestCase {

  fileprivate var json: JSON? = GHAPITestsHelper.jsonObject(named: "User")

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
    let decodePayload = User.decode(json)
    guard
      let payload = decodePayload.value
      else { XCTAssert(false, "payload cannot be constructed \(String(describing: decodePayload.error))"); return }
    XCTAssertEqual(payload.id, 12403137)
    let jsonStr = payload.toJSONString()
    XCTAssertNotNil(jsonStr)
  }
}
