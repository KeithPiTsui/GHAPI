//
//  CreateEventPayload.swift
//  GHAPI
//
//  Created by Pi on 26/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
import Argo
import Curry
import Runes
@testable import GHAPI

internal final class CreateEventPayloadTests: XCTestCase {

  fileprivate var json: JSON? = GHAPITestsHelper.jsonObject(named: "CreateEventPayload")

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
    let decodePayload = CreateEventPayload.decode(json)
    guard
      let payload = decodePayload.value as? CreateEventPayload
      else { XCTAssert(false, "payload cannot be constructed"); return }
    XCTAssertEqual(payload.ref, "0.0.1")
    let jsonStr = payload.toJSONString()
    XCTAssertNotNil(jsonStr)
  }
}
