//
//  TeamAddEventPayload.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
import Argo
import Curry
import Runes
@testable import GHAPI

internal final class TeamAddEventPayloadTests: XCTestCase {

  fileprivate var json: JSON? = GHAPITestsHelper.jsonObject(named: "TeamAddEventPayload")

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
    let decodePayload = TeamAddEventPayload.decode(json)
    guard
      let payload = decodePayload.value as? TeamAddEventPayload
      else { XCTAssert(false, "payload cannot be constructed"); return }
    let jsonStr = payload.toJSONString()
    XCTAssertNotNil(jsonStr)
  }
}
