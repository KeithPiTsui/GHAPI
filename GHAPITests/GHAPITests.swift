//
//  GHAPITests.swift
//  GHAPITests
//
//  Created by Pi on 21/02/2017.
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

class GHAPITests: XCTestCase {
    
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
    
    
    func testGithubService() {
        
        let expectation = self.expectation(description: "network response")
        
        let service = Service.init(serverConfig: ServerConfig.github)

        
        let x = service.testConnectionToGithub()

        x.startWithResult { (result) in
            print(result.value?.id ?? "No value")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 2000, handler: nil)
        
    }
    
    func testGHServiceSearch() {
        let expectation = self.expectation(description: "network response")
        let service = Service()
        let langQualifier: RepositoriesQualifier = .language([.assembly])
        service.search(scope: .repositories([langQualifier]), keyword: "tetris")
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
        
        service.search(scope: .repositories([createdDateQualifier, langQualifier]),
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
    
    
    func testPerformanceExample() {self.measure {}}
}
















































