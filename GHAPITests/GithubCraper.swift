//
//  testGithubCraper.swift
//  GHAPI
//
//  Created by Pi on 14/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
@testable import GHAPI
import PaversFRP
import PaversArgo


internal final class GithubCraperTests: XCTestCase {
  let service = Service()

  fileprivate func run(within timeout: TimeInterval = 10, execute body: (XCTestExpectation) -> () ) {
    let expect = self.expectation(description: "networking")
    body(expect)
    self.waitForExpectations(timeout: timeout, handler: nil)
  }

  func testDailyTrendingSwift() {
    let repos = GithubCraper.trendingRepositories(of: .daily, with: "swift")
    XCTAssert(repos != nil, "Repos should not be nil")
  }

  func testDailyTrendingSignal() {
    run { (expect) in
      service
        .trendingRepository(of: .daily, with: "swift")
        .observe(on: QueueScheduler())
        .startWithResult { (result) in
          defer {expect.fulfill()}
          let errorMsg = result.error.debugDescription
          XCTAssert(result.value != nil, "result should not be nil, error: \(errorMsg)")
      }
    }
  }

  func testAllLanguages() {
    let langs = GithubCraper.programmingLanguages
    XCTAssert(langs.count > 0, "language should be one at least")
  }
}






















