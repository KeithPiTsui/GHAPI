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
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let expectation = self.expectation(description: "network response")

        let urlString =  "https://api.github.com/users/keithpitsui"
        let myUrl = URL(string: urlString);
        let request = NSMutableURLRequest(url:myUrl!);
        request.httpMethod = "GET";
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in

            if let response = response {
                print(response.description)
            }
            
            if let data = data {
                let str = String(data: data, encoding: .utf8)
                print(str ?? "")
            }
            
            
            print("Hello")
            expectation.fulfill()
//            if error != nil {
//                print(error!.localizedDescription)
//                DispatchQueue.main.sync(execute: {
//                    AWLoader.hide()
//                })
//                return
//            }
//            
//            do {
//                
//                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray
//                
//                if let parseJSON = json{
//                    print(parseJSON)
//                } else {
//                    AWLoader.hide()
//                }
//                catch{
//                    AWLoader.hide()
//                    print(error)
//                }
            }
            task.resume()
        
        
//        let service = Service.init(
//            serverConfig: ServerConfig.github,
//            //oauthToken: OauthToken.init(token: "uncomment and put in your token!"),
//            language: "en"
//        )
//        
//        let x = service.testConnectionToGithub()
//        
//        x.startWithResult { (result) in
//            print(result.value?.id ?? "No value")
//            expectation.fulfill()
//        }
        
        self.waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testGithubService() {
        
        let expectation = self.expectation(description: "network response")
        
        let service = Service.init(
            serverConfig: ServerConfig.github,
            //oauthToken: OauthToken.init(token: "uncomment and put in your token!"),
            language: "en"
        )

        
        let x = service.testConnectionToGithub()

        x.startWithResult { (result) in
            print(result.value?.id ?? "No value")
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
