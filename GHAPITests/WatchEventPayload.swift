//
//  WatchEventPayload.swift
//  GHAPI
//
//  Created by Pi on 26/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
import PaversFRP
import PaversArgo
@testable import GHAPI

internal final class WatchEventPayloadTests: XCTestCase {

  fileprivate var json: JSON? = GHAPITestsHelper.jsonObject(named: "WatchEventPayload")

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
    let decodePayload = WatchEventPayload.decode(json)
    guard
      let payload = decodePayload.value as? WatchEventPayload
      else { XCTAssert(false, "payload cannot be constructed \(decodePayload.error)"); return }
    XCTAssertEqual(payload.action, "started")
    let jsonStr = payload.toJSONString()
    XCTAssertNotNil(jsonStr)
  }
}
