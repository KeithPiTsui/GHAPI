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
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
            print(result.value?.debugDescription ?? "No value")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 2000, handler: nil)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
