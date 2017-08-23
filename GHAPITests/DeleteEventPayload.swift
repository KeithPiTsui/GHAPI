//
//  DeleteEventPayload.swift
//  GHAPI
//
//  Created by Pi on 26/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
import PaversFRP
import PaversArgo
@testable import GHAPI

internal final class DeleteEventPayloadTests: XCTestCase {

  fileprivate var json: JSON? = GHAPITestsHelper.jsonObject(named: "DeleteEventPayload")

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
    let decodePayload = DeleteEventPayload.decode(json)
    guard
      let payload = decodePayload.value as? DeleteEventPayload
      else { XCTAssert(false, "payload cannot be constructed"); return }
    XCTAssertEqual(payload.ref, "simple-tag")
    let jsonStr = payload.toJSONString()
    XCTAssertNotNil(jsonStr)
  }
}
