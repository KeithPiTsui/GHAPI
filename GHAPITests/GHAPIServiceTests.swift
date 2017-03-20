//
//  GHAPIServiceTests.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
@testable import GHAPI
import Argo
import Curry
import Runes
import ReactiveSwift
import Result

internal final class GHAPIServiceTests: XCTestCase {

  let service = Service()

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  fileprivate func run(within timeout: TimeInterval = 10, execute body: (XCTestExpectation) -> () ) {
    let expect = self.expectation(description: "networking")
    body(expect)
    self.waitForExpectations(timeout: 10, handler: nil)
  }

  func testLogin() {

  }

  func testRepository() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/repos/apple/swift")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }
      service.repository(referredBy: url).observeInBackground()
        .startWithResult{ (result) in
          defer { expect.fulfill() }
          let repo = result.value
          XCTAssertNotNil(repo, "commit request result should not be nil")
      }
    }
  }

  func testCommit() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/repos/apple/swift/commits/39639fd3b8c5c1eb2fcaf6d565d23975a55b528d")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }
      service.commit(referredBy: url).observeInBackground()
        .startWithResult{ (result) in
          defer { expect.fulfill() }
          let commit = result.value
          XCTAssertNotNil(commit, "commit request result should not be nil")
        }
    }
  }

  func testCommits() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/repos/apple/swift/commits")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }
      service.commits(referredBy: url).observeInBackground()
        .startWithResult{ (result) in
          defer { expect.fulfill() }
          let commits = result.value
          XCTAssertNotNil(commits, "commit request result should not be nil")
      }
    }
  }

  func testBranch() {
    run { (expect) in
      guard let url =
        URL(string: "https://api.github.com/repos/apple/swift/branches/swift-3.0-branch")
        else {  XCTAssert(false, "branches test URL cannot be constructed"); return }
      service.branch(referredBy: url).observeInBackground()
        .startWithResult{ (result) in
          defer {expect.fulfill()}
          let branches = result.value
          XCTAssertNotNil(branches, "commit request result should not be nil")
      }
    }
  }


  func testBranchLites() {
    run { (expect) in
      guard let url =
        URL(string: "https://api.github.com/repos/apple/swift/branches")
        else {  XCTAssert(false, "branches test URL cannot be constructed"); return }
      service.branchLites(referredBy: url).observeInBackground()
        .startWithResult{ (result) in
          defer {expect.fulfill()}
          let branches = result.value
          XCTAssertNotNil(branches, "commit request result should not be nil")
        }
    }
  }

  func testRequestError() {
    run { (expect) in
      service
        .user(with: "asdinefnasdfowefn")
        .startWithResult { (result) in
          defer {expect.fulfill()}
          XCTAssert(result.error != nil, "This should be error.")
      }
    }
  }



  func testServiceReceivedEvents() {
    run { (expect) in
      service
        .receivedEvents(of: "keithpitsui")
        .observeInBackground()
        .startWithResult {[weak self] (result) in
          defer {expect.fulfill()}
          XCTAssert(result.value != nil, "Cannot get received event")
      }
    }
  }

  func testServiceEvents() {
    run { (expect) in
      service
        .events(of: "keithpitsui")
        .observeInBackground()
        .startWithResult {[weak self] (result) in
          defer {expect.fulfill()}
          XCTAssert(result.value != nil, "Cannot get received event")
      }
    }
  }

  func testGHServiceSearch() {
    run { (expect) in
      let langQualifier: RepositoriesQualifier = .language([.assembly])
      service
        .searchRepository(qualifiers: [langQualifier], keyword: "tetris")
        .startWithResult {(result) in
          defer {expect.fulfill()}
          let errorMsg = result.error.debugDescription
          XCTAssert(result.value != nil, "result should not be nil, error: \(errorMsg)")
      }
    }
  }

  func testGHServiceTrendingRepos() {
    run { (expect) in
      let createdDateQualifier: RepositoriesQualifier = .pushed(.biggerAndEqualThan(Date() - 7*24*50))
      let langQualifier: RepositoriesQualifier = .language([.swift])
      service
        .searchRepository(qualifiers: [createdDateQualifier, langQualifier],
                          sort: .stars,
                          order: .desc)
        .startWithResult {(result) in
          defer {expect.fulfill()}
          let errorMsg = result.error.debugDescription
          XCTAssert(result.value != nil, "result should not be nil, error: \(errorMsg)")
      }
    }
  }

  func testGHServiceUserSearch() {
    run { (expect) in
      let userTypeQualifier: UserQualifier = .type(.user)
      service
        .searchUser(qualifiers: [userTypeQualifier],
                    keyword: "Keith",
                    sort: .stars,
                    order: .desc)
        .startWithResult {(result) in
          defer {expect.fulfill()}
          let errorMsg = result.error.debugDescription
          XCTAssert(result.value != nil, "result should not be nil, error: \(errorMsg)")
      }
    }
  }

  func testGHServiceUserWithURL() {
    run { (expect) in
      let url = URL(string: "https://api.github.com/users/apple")!
      service
        .user(referredBy: url)
        .startWithResult { (result) in
          defer {expect.fulfill()}
          let errorMsg = result.error.debugDescription
          XCTAssert(result.value != nil, "result should not be nil, error: \(errorMsg)")
      }
    }
  }


  func testReadmeService() {
    run { (expect) in
      let url = URL(string: "https://api.github.com/repos/ReactiveCocoa/ReactiveCocoa/readme")!
      service
        .readme(referredBy: url)
        .startWithResult { (result) in
          defer {expect.fulfill()}
          XCTAssert(result.value != nil, "result should not be nil")
      }
    }
  }
}
