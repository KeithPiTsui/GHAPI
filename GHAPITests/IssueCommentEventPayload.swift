//
//  IssueCommentEventPayload.swift
//  GHAPI
//
//  Created by Pi on 21/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
import PaversFRP
import PaversArgo
@testable import GHAPI

internal final class IssueCommentEventPayloadTests: XCTestCase {

  fileprivate var json: JSON? = GHAPITestsHelper.jsonObject(named: "IssueCommentEventPayload")

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
    let decodePayload = IssueCommentEventPayload.decode(json)
    guard
      let payload = decodePayload.value as? IssueCommentEventPayload
      else { XCTAssert(false, "payload cannot be constructed"); return }
    XCTAssertEqual(payload.action, "created")
    let jsonStr = payload.toJSONString()
    XCTAssertNotNil(jsonStr)
  }
}
