//
//  GHOrganizationEventTests.swift
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

internal final class GHOrganizationEventTests: XCTestCase {

  fileprivate var json: JSON? = GHAPITestsHelper.setupJson(named: "OrganizationEventPayload")

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
    let decodePayload = OrganizationEventPayload.decode(json)
    guard
      let payload = decodePayload.value as? OrganizationEventPayload
      else { XCTAssert(false, "payload cannot be constructed"); return }
    XCTAssertEqual(payload.action, "member_invited")
  }
}










