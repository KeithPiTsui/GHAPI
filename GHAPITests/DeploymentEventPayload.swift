//
//  DeploymentEventPayload.swift
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

internal final class DeploymentEventPayloadTests: XCTestCase {

  fileprivate var json: JSON? = GHAPITestsHelper.jsonObject(named: "DeploymentEventPayload")

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
    let decodePayload = DeploymentEventPayload.decode(json)
    guard
      let payload = decodePayload.value as? DeploymentEventPayload
      else { XCTAssert(false, "payload cannot be constructed \(decodePayload.error)"); return }
    XCTAssertEqual(payload.deployment.id, 710692)
    let jsonStr = payload.toJSONString()
    XCTAssertNotNil(jsonStr)
  }
}
