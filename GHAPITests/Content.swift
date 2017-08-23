//
//  Content.swift
//  GHAPI
//
//  Created by Pi on 20/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
import PaversFRP
import PaversArgo
@testable import GHAPI

internal final class ContentTests: XCTestCase {

  fileprivate var json: JSON? = GHAPITestsHelper.jsonObject(named: "Content")

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
    let decodePayload = Content.decode(json)
    guard
      let payload = decodePayload.value
      else { XCTAssert(false, "payload cannot be constructed"); return }
    XCTAssertEqual(payload.sha, "2993037ec17800276816444d4b0b0255417ab870")
    let jsonStr = payload.toJSONString()
    XCTAssertNotNil(jsonStr)
    let contentStr = payload.plainContent
    print("\(contentStr)")
  }
}


