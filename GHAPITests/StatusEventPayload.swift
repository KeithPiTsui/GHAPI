//
//  StatusEventPayload.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
import PaversFRP
import PaversArgo
@testable import GHAPI

internal final class StatusEventPayloadTests: XCTestCase {

  fileprivate var json: JSON? = GHAPITestsHelper.jsonObject(named: "StatusEventPayload")

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
    let decodePayload = StatusEventPayload.decode(json)
    guard
      let payload = decodePayload.value as? StatusEventPayload
      else { XCTAssert(false, "payload cannot be constructed"); return }
    XCTAssertEqual(payload.id, 214015194)
    let jsonStr = payload.toJSONString()
    XCTAssertNotNil(jsonStr)
  }
}
