//
//  Commit.swift
//  GHAPI
//
//  Created by Pi on 20/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
import Argo
import Curry
import Runes
@testable import GHAPI

internal final class CommitTests: XCTestCase {

  fileprivate var json: JSON? = GHAPITestsHelper.jsonObject(named: "Commit")

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
    let decodeCommit = Commit.decode(json)
    guard
      let commit = decodeCommit.value
      else { XCTAssert(false, "payload cannot be constructed"); return }
    XCTAssertEqual(commit.sha, "39639fd3b8c5c1eb2fcaf6d565d23975a55b528d")
    let jsonStr = commit.toJSONString()
    XCTAssertNotNil(jsonStr)
  }
}
