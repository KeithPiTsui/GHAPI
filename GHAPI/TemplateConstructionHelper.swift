//
//  TemplateConstructionHelper.swift
//  GHAPI
//
//  Created by Pi on 11/04/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP

import Foundation

fileprivate class A {}

public enum TemplateConstructionHelper {
  public static func jsonObject(named filename: String, and fileextension: String = "json") -> JSON? {
    let bundle = Bundle(for: A.self)
    guard
      let filePath = bundle.path(
        forResource: filename,
        ofType: fileextension,
        inDirectory: nil)
      else { return nil }
    let fileURL = URL(fileURLWithPath: filePath)
    guard
      let jsonData = try? Data(contentsOf: fileURL)
      else { return nil }
    guard
      let parsedJson = try? JSONSerialization.jsonObject(with: jsonData, options: [])
      else { return nil }
    return JSON(parsedJson)
  }

  public static func jsonString(named filename: String, and fileextension: String = "json") -> String? {
    let bundle = Bundle(for: A.self)
    guard
      let filePath = bundle.path(
        forResource: filename,
        ofType: fileextension,
        inDirectory: nil)
      else { return nil }
    let fileURL = URL(fileURLWithPath: filePath)
    guard
      let jsonStr = try? String(contentsOf: fileURL)
      else { return nil }
    return jsonStr
  }

}
