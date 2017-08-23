//
//  ForkEventPayload.swift
//  GHAPI
//
//  Created by Pi on 26/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
import PaversFRP
import PaversArgo
@testable import GHAPI

internal final class ForkEventPayloadTests: XCTestCase {

  fileprivate var json: JSON? = GHAPITestsHelper.jsonObject(named: "ForkEventPayload")

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
    let decodePayload = ForkEventPayload.decode(json)
    guard
      let payload = decodePayload.value as? ForkEventPayload
      else { XCTAssert(false, "payload cannot be constructed \(decodePayload.error)"); return }
    XCTAssertEqual(payload.forkee.id, 35129393)
    let jsonStr = payload.toJSONString()
    XCTAssertNotNil(jsonStr)
  }
}
