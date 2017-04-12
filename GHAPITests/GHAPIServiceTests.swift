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
    self.waitForExpectations(timeout: timeout, handler: nil)
  }

  func testApiRoots() {
    run { (expect) in
      service.apiRoots().observeInBackground().startWithResult{ (result) in
        defer { expect.fulfill() }
        let roots = result.value
        XCTAssertNotNil(roots, "commit request result should not be nil")
      }
    }
  }

  func testLogin() {

  }

  func testContentFromRepository() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/repos/apple/swift")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }

      let repository = service.repository(referredBy: url).observeInBackground()
      let content = repository
        .concatMap{ [weak self] (repo) -> SignalProducer<[Content], ErrorEnvelope> in
          guard let serv = self?.service else {
            return SignalProducer<[Content], ErrorEnvelope>(error: ErrorEnvelope.unknownError)
          }
          return serv.contents(of: repo, ref: nil)
      }
      content.startWithResult{ (result) in
        defer { expect.fulfill() }
        let repo = result.value
        XCTAssertNotNil(repo, "commit request result should not be nil")
      }
    }
  }

  func testContentFromURL() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/repos/apple/swift")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }

      service.contents(ofRepository: url, ref: "master").observeInBackground().startWithResult{ (result) in
        defer { expect.fulfill() }
        let repo = result.value
        XCTAssertNotNil(repo, "commit request result should not be nil")
      }
    }
  }


  func testRepository() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/repos/apple/swift")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }

      let repository = service.repository(referredBy: url).observeInBackground()
      let content = repository
        .concatMap{ [weak self] (repo) -> SignalProducer<[Content], ErrorEnvelope> in
          guard let serv = self?.service else {
            return SignalProducer<[Content], ErrorEnvelope>(error: ErrorEnvelope.unknownError)
          }
          return serv.contents(of: repo, ref: nil)
      }

      content.startWithResult{ (result) in
        defer { expect.fulfill() }
        let repo = result.value
        XCTAssertNotNil(repo, "commit request result should not be nil")
      }
    }
  }

  func testRepoContributors() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/repos/apple/swift")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }

      let repository = service.repository(referredBy: url).observeInBackground()
      let forks = repository
        .concatMap{ [weak self] (repo) -> SignalProducer<[UserLite], ErrorEnvelope> in
          guard let serv = self?.service else {
            return SignalProducer<[UserLite], ErrorEnvelope>(error: ErrorEnvelope.unknownError)
          }
          return serv.contributors(of: repo)
      }
      forks.startWithResult{ (result) in
        defer { expect.fulfill() }
        let repo = result.value
        XCTAssertNotNil(repo, "commit request result should not be nil")
      }

    }
  }
  func testRepoStargazers() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/repos/apple/swift")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }

      let repository = service.repository(referredBy: url).observeInBackground()
      let forks = repository
        .concatMap{ [weak self] (repo) -> SignalProducer<[UserLite], ErrorEnvelope> in
          guard let serv = self?.service else {
            return SignalProducer<[UserLite], ErrorEnvelope>(error: ErrorEnvelope.unknownError)
          }
          return serv.stargazers(of: repo)
      }
      forks.startWithResult{ (result) in
        defer { expect.fulfill() }
        let repo = result.value
        XCTAssertNotNil(repo, "commit request result should not be nil")
      }

    }
  }
  func testRepoPullRequests() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/repos/apple/swift")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }

      let repository = service.repository(referredBy: url).observeInBackground()
      let forks = repository
        .concatMap{ [weak self] (repo) -> SignalProducer<[PullRequest], ErrorEnvelope> in
          guard let serv = self?.service else {
            return SignalProducer<[PullRequest], ErrorEnvelope>(error: ErrorEnvelope.unknownError)
          }
          return serv.pullRequests(of: repo)
      }
      forks.startWithResult{ (result) in
        defer { expect.fulfill() }
        let repo = result.value
        XCTAssertNotNil(repo, "commit request result should not be nil \(result.error)")
      }

    }
  }
  func testRepoIssues() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/repos/apple/swift")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }

      let repository = service.repository(referredBy: url).observeInBackground()
      let forks = repository
        .concatMap{ [weak self] (repo) -> SignalProducer<[Issue], ErrorEnvelope> in
          guard let serv = self?.service else {
            return SignalProducer<[Issue], ErrorEnvelope>(error: ErrorEnvelope.unknownError)
          }
          return serv.issues(of: repo)
      }
      forks.startWithResult{ (result) in
        defer { expect.fulfill() }
        let repo = result.value
        XCTAssertNotNil(repo, "commit request result should not be nil")
      }

    }
  }

  func testPersonalRepos() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/users/keithPitsui")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }

      let user = service.user(referredBy: url).observeInBackground()
      let repos = user
        .concatMap{ [weak self] (u) -> SignalProducer<[Repository], ErrorEnvelope> in
          guard let serv = self?.service else {
            return SignalProducer<[Repository], ErrorEnvelope>(error: ErrorEnvelope.unknownError)
          }
          return serv.personalRepositories(of: u)
      }
      repos.startWithResult{ (result) in
        defer { expect.fulfill() }
        let es = result.value
        XCTAssertNotNil(es, "commit request result should not be nil")
      }
      
    }
  }

  func testStarredRepos() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/users/keithPitsui")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }

      let user = service.user(referredBy: url).observeInBackground()
      let repos = user
        .concatMap{ [weak self] (u) -> SignalProducer<[Repository], ErrorEnvelope> in
          guard let serv = self?.service else {
            return SignalProducer<[Repository], ErrorEnvelope>(error: ErrorEnvelope.unknownError)
          }
          return serv.starredRepositories(of: u)
      }
      repos.startWithResult{ (result) in
        defer { expect.fulfill() }
        let es = result.value
        XCTAssertNotNil(es, "commit request result should not be nil")
      }

    }
  }

  func testCommitOfRepositoryOnBranch() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/repos/apple/swift")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }
      let repository = service.repository(referredBy: url).observeInBackground()
      let branches = repository
        .concatMap{ [weak self] (repo) -> SignalProducer<[BranchLite], ErrorEnvelope> in
          guard let serv = self?.service else {
            return SignalProducer<[BranchLite], ErrorEnvelope>(error: ErrorEnvelope.unknownError)
          }
          return serv.branchLites(referredBy: repo.urls.branches_url)
      }

      let commits = SignalProducer.combineLatest(repository, branches)
        .concatMap{ [weak self] (repo, branches) -> SignalProducer<[Commit], ErrorEnvelope> in
        guard let serv = self?.service, let branch = branches.first else {
          return SignalProducer<[Commit], ErrorEnvelope>(error: ErrorEnvelope.unknownError)
        }
        return serv.commits(of: repo, on: branch)
      }
      commits.startWithResult{ (result) in
        defer { expect.fulfill() }
        let es = result.value
        XCTAssertNotNil(es, "commit request result should not be nil")
      }

    }
  }

//  func testGHEventsWithLinks() {
//    run { (expect) in
//      guard
//        let url
//        = URL(string: "https://api.github.com/users/KeithPitsui/received_events")
//        else { XCTAssert(false, "commit test URL cannot be constructed"); return }
//
//      service.reve(of: url).observeInBackground().startWithResult{ (result) in
//        defer { expect.fulfill() }
//        if let value = result.value {
//          let events = value.0
//          let links = value.1
//          print("received \(events.count) events")
//          print("links: \(String(describing: links))")
//        } else {
//          let error = result.error
//          print("error: \(String(describing: error))")
//        }
//      }
//    }
//  }

  func testRepoActivities() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/repos/apple/swift")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }

      let repository = service.repository(referredBy: url).observeInBackground()
      let events = repository
        .concatMap{ [weak self] (repo) -> SignalProducer<[GHEvent], ErrorEnvelope> in
          guard let serv = self?.service else {
            return SignalProducer<[GHEvent], ErrorEnvelope>(error: ErrorEnvelope.unknownError)
          }
          return serv.events(of: repo)
      }
      events.startWithResult{ (result) in
        defer { expect.fulfill() }
        let es = result.value
        XCTAssertNotNil(es, "commit request result should not be nil")
      }

    }
  }

  func testRepoRelease() {
    run { (expect) in
      guard
        let url 
        = URL(string: "https://api.github.com/repos/apple/swift")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }

      let repository = service.repository(referredBy: url).observeInBackground()
      let forks = repository
        .concatMap{ [weak self] (repo) -> SignalProducer<[Release], ErrorEnvelope> in
          guard let serv = self?.service else {
            return SignalProducer<[Release], ErrorEnvelope>(error: ErrorEnvelope.unknownError)
          }
          return serv.releases(of: repo)
      }
      forks.startWithResult{ (result) in
        defer { expect.fulfill() }
        let repo = result.value
        XCTAssertNotNil(repo, "commit request result should not be nil")
      }

    }
  }

  func testRepoForks() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/repos/apple/swift")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }

      let repository = service.repository(referredBy: url).observeInBackground()
      let forks = repository
        .concatMap{ [weak self] (repo) -> SignalProducer<[Repository], ErrorEnvelope> in
          guard let serv = self?.service else {
            return SignalProducer<[Repository], ErrorEnvelope>(error: ErrorEnvelope.unknownError)
          }
          return serv.forks(of: repo)
      }
      forks.startWithResult{ (result) in
        defer { expect.fulfill() }
        let repo = result.value
        XCTAssertNotNil(repo, "commit request result should not be nil")
      }

    }
  }

  func testPullRequestReferedByURL() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/repos/ArtSabintsev/Guitar/pulls/16")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }
      service.pullRequest(of: url).observeInBackground()
        .startWithResult{ (result) in
          defer { expect.fulfill() }
          let pr = result.value
          XCTAssertNotNil(pr, "pull request result should not be nil")
      }
    }
  }

  func testCommentsOfPullRequest() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/repos/ArtSabintsev/Guitar/pulls/16")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }
      let pr = service.pullRequest(of: url).observeInBackground()
      let comments = pr.flatMap{ [weak self] (pr) -> SignalProducer<[IssueComment], ErrorEnvelope> in
        guard let serv = self?.service
          else { return SignalProducer<[IssueComment], ErrorEnvelope>(error: ErrorEnvelope.unknownError)}
        return serv.pullRequestComments(of: pr)
      }
      comments.startWithResult{ (result) in
        defer { expect.fulfill() }
        let cs = result.value
        XCTAssertNotNil(cs, "comments of pull request result should not be nil")
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

  func testCommitComment() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/repos/apple/swift/commits/39639fd3b8c5c1eb2fcaf6d565d23975a55b528d")
        else { XCTAssert(false, "commit test URL cannot be constructed"); return }
      let commit = service.commit(referredBy: url).observeInBackground()
      let comments = commit.concatMap{ [weak self] (commit) -> SignalProducer<[CommitComment], ErrorEnvelope> in
        guard let serv = self?.service else {
          return SignalProducer<[CommitComment], ErrorEnvelope>(error: ErrorEnvelope.unknownError)
        }
        return serv.comments(of: commit)
      }
      comments.startWithResult{ (result) in
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

  func testIssue() {
    run { (expect) in
      guard let url =
        URL(string: "https://api.github.com/repos/danielgindi/Charts/issues/2225")
        else {  XCTAssert(false, "Issue test URL cannot be constructed"); return }
      service.issue(of: url).observeInBackground()
        .startWithResult{ (result) in
          defer {expect.fulfill()}
          let branches = result.value
          XCTAssertNotNil(branches, "commit request result should not be nil")
      }
    }
  }

  func testIssueComments() {
    run { (expect) in
      guard
        let url
        = URL(string: "https://api.github.com/repos/danielgindi/Charts/issues/2225")
        else { XCTAssert(false, "IssueComments test URL cannot be constructed"); return }

      let issue = service.issue(of: url).observeInBackground()
      let comments = issue
        .concatMap{ [weak self] (i) -> SignalProducer<[IssueComment], ErrorEnvelope> in
          guard let serv = self?.service else {
            return SignalProducer<[IssueComment], ErrorEnvelope>(error: ErrorEnvelope.unknownError)
          }
          return serv.issueComments(of: i)
      }
      comments.startWithResult{ (result) in
        defer { expect.fulfill() }
        let repo = result.value
        XCTAssertNotNil(repo, "IssueComments request result should not be nil")
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
      service.user(with: "keithpitsui")
        .concatMap{ [weak self] (user) -> SignalProducer<[GHEvent], ErrorEnvelope> in
          return self?.service.receivedEvents(of: user)
            ?? SignalProducer.init(error: ErrorEnvelope.unknownError)
        }.observeInBackground()
        .startWithResult {[weak self] (result) in
          defer {expect.fulfill()}
          XCTAssert(result.value != nil, "Cannot get received event")
      }
    }
  }

  func testServiceEvents() {
    run { (expect) in
      service.user(with: "keithpitsui")
        .concatMap{ [weak self] (user) -> SignalProducer<[GHEvent], ErrorEnvelope> in
          return self?.service.events(of: user)
            ?? SignalProducer.init(error: ErrorEnvelope.unknownError)
        }.observeInBackground()
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













