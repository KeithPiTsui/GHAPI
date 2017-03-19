//
//  Event.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
import Argo
import Curry
import Runes
@testable import GHAPI

internal final class Event: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    internal func testEventTypeAndItsConstructor() {
      let eventTypes = GHEvent.EventType.allCases.map{$0.rawValue}
      let eventTypeConstructors = GHEvent.payloadConstructorDict.keys.map{$0.rawValue}
      let rest = eventTypes.filter { !eventTypeConstructors.contains($0)}
      print(rest)
      XCTAssert(rest.count == 0, "Every event type should have a constructor")
      let constructors1 = GHEvent.payloadConstructorDict.values
      constructors1.forEach { (t1) in
        let x = constructors1.filter { (t2) -> Bool in t1 == t2}
        XCTAssert(x.count == 1, "Each constructor should occur once")
      }
    }
}
