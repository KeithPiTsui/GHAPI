//
//  LabelEventPayload.swift
//  GHAPI
//
//  Created by Pi on 26/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
import PaversFRP
import PaversArgo
@testable import GHAPI

internal final class LabelEventPayloadTests: XCTestCase {

  fileprivate var json: JSON? = GHAPITestsHelper.jsonObject(named: "LabelEventPayload")

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
    let decodePayload = LabelEventPayload.decode(json)
    guard
      let payload = decodePayload.value as? LabelEventPayload
      else { XCTAssert(false, "payload cannot be constructed \(decodePayload.error)"); return }
    XCTAssertEqual(payload.action, "created")
    let jsonStr = payload.toJSONString()
    XCTAssertNotNil(jsonStr)
  }
}
