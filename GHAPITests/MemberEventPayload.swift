//
//  MemberEventPayload.swift
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

internal final class MemberEventPayloadTests: XCTestCase {

  fileprivate var json: JSON? = GHAPITestsHelper.jsonObject(named: "MemberEventPayload")

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
    let decodePayload = MemberEventPayload.decode(json)
    guard
      let payload = decodePayload.value as? MemberEventPayload
      else { XCTAssert(false, "payload cannot be constructed \(decodePayload.error)"); return }
    XCTAssertEqual(payload.action, "added")
    let jsonStr = payload.toJSONString()
    XCTAssertNotNil(jsonStr)
  }
}
