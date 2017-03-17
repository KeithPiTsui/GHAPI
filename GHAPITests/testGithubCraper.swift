//
//  testGithubCraper.swift
//  GHAPI
//
//  Created by Pi on 14/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
@testable import GHAPI
import UIKit
import Argo
import Curry
import Prelude
import Runes
import ReactiveSwift
import Result
import ReactiveExtensions

class testGithubCraper: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testJiFramework() {
    //        let i = "1,234".numbers().first
    //        let i2 = "1234".numbers().first
    //        testJi()
  }

  func testDailyTrendingSwift() {
    //        let repos = GithubCraper.trendingRepositories(of: .daily, with: "swift")

    print("Hello")
  }

  func testDailyTrendingSignal() {
//    let expectation = self.expectation(description: "network response")
//    let service = Service()
//    service.trendingRepository(of: .daily, with: "swift")
//      .observe(on: QueueScheduler())
//      .startWithResult { (result) in
//
//        if let reposValue = result.value {
//          if let repos = reposValue {
//            print("\(repos.count)")
//          }
//        }
//        expectation.fulfill()
//    }
//
//    self.waitForExpectations(timeout: 2000, handler: nil)
  }


  func testAllLanguages() {
    _ = self.expectation(description: "network response")

    let langs = GithubCraper.programmingLanguages

    print(langs)

    self.waitForExpectations(timeout: 2000, handler: nil)
  }


  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }

}






















