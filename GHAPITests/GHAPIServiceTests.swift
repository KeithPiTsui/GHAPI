//
//  GHAPIServiceTests.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
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

class GHAPIServiceTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testExample() {
    //      let urlString =  "https://api.github.com/users/keithpitsui"
    let urlString =  "https://api.github.com/search/repositories?q=tetris+language:assembly&sort=stars&order=desc"
    self.linkRequest(link: urlString)

  }

  fileprivate func linkRequest(link: String) {
    let expectation = self.expectation(description: "network response")
    let urlString = link
    let myUrl = URL(string: urlString);
    let request = NSMutableURLRequest(url:myUrl!);
    request.httpMethod = "GET";
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
      data, response, error in
      if let response = response { print(response.description) }
      if let data = data { print(String(data: data, encoding: .utf8) ?? "")}
      expectation.fulfill()
    }
    task.resume()
    self.waitForExpectations(timeout: 200, handler: nil)
  }


  func testGHServiceSearch() {
    let expectation = self.expectation(description: "network response")
    let service = Service()
    let langQualifier: RepositoriesQualifier = .language([.assembly])
    service.searchRepository(qualifiers: [langQualifier], keyword: "tetris")
      .startWithResult {(result) in
        if let value  = result.value {
          print(value.debugDescription)
        }
        if let error = result.error {
          print(error.localizedDescription)
        }
        expectation.fulfill()
    }
    self.waitForExpectations(timeout: 2000, handler: nil)
  }

  func testGHServiceTrendingRepos() {
    let expectation = self.expectation(description: "network response")
    let service = Service()
    let createdDateQualifier: RepositoriesQualifier = .pushed(.biggerAndEqualThan(Date() - 7*24*50))
    let langQualifier: RepositoriesQualifier = .language([.swift])

    service.searchRepository(qualifiers: [createdDateQualifier, langQualifier],
                             sort: .stars,
                             order: .desc)
      .startWithResult {(result) in
        if let value  = result.value {
          print(value.debugDescription)
        }
        if let error = result.error {
          print(error.localizedDescription)
        }
        expectation.fulfill()
    }

    self.waitForExpectations(timeout: 2000, handler: nil)
  }

  func testGHServiceUserSearch() {
    let expectation = self.expectation(description: "network response")
    let service = Service()

    let userTypeQualifier: UserQualifier = .type(.user)
    service.searchUser(qualifiers: [userTypeQualifier],
                        keyword: "Keith",
                        sort: .stars,
                        order: .desc)
      .startWithResult {(result) in
        if let value  = result.value {
          print(value.debugDescription)
          print(value.items.first?.id)
        }
        if let error = result.error {
          print(error.localizedDescription)
        }
        expectation.fulfill()
    }

    self.waitForExpectations(timeout: 2000, handler: nil)
  }

  func testGHServiceUserWithURL() {
    let expectation = self.expectation(description: "network response")
    let service = Service()
    let url = URL(string: "https://api.github.com/users/apple")!
    service.user(referredBy: url).startWithResult { (result) in
      if let value  = result.value {
        print(value.debugDescription)
      }
      if let error = result.error {
        print(error.localizedDescription)
      }
      expectation.fulfill()

    }

    self.waitForExpectations(timeout: 2000, handler: nil)
  }


  func testJsonEncode() {
    let expectation = self.expectation(description: "network response")
    let urlString = "https://api.github.com/repos/keith/asc_476/branches"
    let myUrl = URL(string: urlString);
    let request = NSMutableURLRequest(url:myUrl!);
    request.httpMethod = "GET";
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
      data, response, error in
      guard let response = response,
        let data = data  else { return }
      guard let object = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) else { return }
      let result: Decoded<[Branch]> = decode(object)
      print("hello")
      guard let branch = result.value?.first else { return }
      let str = branch.toJSONString()

      expectation.fulfill()
    }
    task.resume()
    self.waitForExpectations(timeout: 2000, handler: nil)
  }

  func testDirectJsonDecode() {
    let jsonStr = "{\"name\":\"master\",\"commit\":{\"sha\":\"3eef257b8166bd1450dda32ec3c722a7d1b4533f\",\"url\":\"https://api.github.com/repos/keith/asc_476/commits/3eef257b8166bd1450dda32ec3c722a7d1b4533f\"}}"
    let result:Branch? = decode(jsonStr)


  }

  func testSanitizedUrl() {
    let str = "https://api.github.com/repos/keith/asc_476/assignees{/user}"
    //        let s = str.sanitizedUrlStr
    let s = str.ghUrlPatternRemoved
  }

  func testReadmeResponse() {
    let expectation = self.expectation(description: "network response")
    let urlString = "https://api.github.com/repos/ReactiveCocoa/ReactiveCocoa/readme"
    let myUrl = URL(string: urlString);
    let request = NSMutableURLRequest(url:myUrl!);
    request.httpMethod = "GET";
    request.allHTTPHeaderFields?["Accept"] = "application/vnd.github.v3.html"
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
      data, response, error in
      guard let response = response,
        let data = data  else { return }

      let str = String(data: data, encoding: .utf8)
      print(str)


      expectation.fulfill()
    }
    task.resume()
    self.waitForExpectations(timeout: 2000, handler: nil)
  }

  func testReadmeService() {
    let expectation = self.expectation(description: "network response")
    let service = Service()
    let url = URL(string: "https://api.github.com/repos/ReactiveCocoa/ReactiveCocoa/readme")!
    service.readme(referredBy: url).startWithResult { (result) in
      if let value  = result.value {
        print(value.debugDescription)
        if let data = Data(base64Encoded: value.content, options: .ignoreUnknownCharacters) {
          let str = String(data: data, encoding: String.Encoding.utf8)
          print(str)
        }

      }
      if let error = result.error {
        print(error.localizedDescription)
      }
      expectation.fulfill()

    }

    self.waitForExpectations(timeout: 2000, handler: nil)
  }



  func testPerformanceExample() {self.measure {}}








  func testEventJsonEncode() {
    let expectation = self.expectation(description: "network response")
    let urlString = "https://api.github.com/users/keithPitsui/events?per_page=1"
    let myUrl = URL(string: urlString);
    let request = NSMutableURLRequest(url:myUrl!);
    request.httpMethod = "GET";
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
      data, response, error in
      guard let response = response,
        let data = data  else { return }
      guard let object = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) else { return }
      let result: Decoded<[GHEvent]> = decode(object)
      print("hello")
      guard let branch = result.value?.first else { return }
      //            let str = branch.toJSONString()

      expectation.fulfill()
    }
    task.resume()
    self.waitForExpectations(timeout: 2000, handler: nil)
  }
  
  func testJiFramework() {
    
  }
  
  
}
















































