//
//  GHAPITestsHelper.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes
import Foundation
import XCTest

fileprivate class A {}

internal enum GHAPITestsHelper {
  internal static func jsonObject(named filename: String, and fileextension: String = "json") -> JSON? {
    let bundle = Bundle(for: A.self)
    guard
      let filePath = bundle.path(
        forResource: filename,
        ofType: fileextension,
        inDirectory: nil)
      else { XCTAssert(false, "No corresponding json file \(filename).\(fileextension)"); return nil }
    let fileURL = URL(fileURLWithPath: filePath)
    guard
      let jsonData = try? Data(contentsOf: fileURL)
      else { XCTAssert(false, "Cannot extract data from file \(fileURL)"); return nil }
    guard
      let parsedJson = try? JSONSerialization.jsonObject(with: jsonData, options: [])
      else { XCTAssert(false, "Cannot parse data into json from file \(fileURL)"); return nil }
    return JSON(parsedJson)
  }

  internal static func jsonString(named filename: String, and fileextension: String = "json") -> String? {
    let bundle = Bundle(for: A.self)
    guard
      let filePath = bundle.path(
        forResource: filename,
        ofType: fileextension,
        inDirectory: nil)
      else { XCTAssert(false, "No corresponding json file \(filename).\(fileextension)"); return nil }
    let fileURL = URL(fileURLWithPath: filePath)
    guard
      let jsonStr = try? String(contentsOf: fileURL)
      else { XCTAssert(false, "Cannot extract string from file \(fileURL)"); return nil }
    return jsonStr
  }
}



