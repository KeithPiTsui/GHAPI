//
//  GHErrorEnvelope.swift
//  GHAPI
//
//  Created by Pi on 29/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation
import PaversArgo
import PaversFRP


public struct GHErrorEnvelope {
  public struct GHError {
    public let resource: String
    public let field: String
    public let code: String
  }
  public let message: String
  public let errors: [GHErrorEnvelope.GHError]?
}

extension GHErrorEnvelope: GHAPIModelType {
  public static func == (lhs: GHErrorEnvelope, rhs: GHErrorEnvelope) -> Bool {
    return lhs.message == rhs.message
  }
  public static func decode(_ json: JSON) -> Decoded<GHErrorEnvelope> {
    let creator = curry(GHErrorEnvelope.init)
    let tmp = creator
      <^> json <| "message"
      <*> json <||? "errors"
    return tmp
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["message"] = self.message
    result["errors"] = self.errors?.map{$0.encode()}
    return result
  }
}

extension GHErrorEnvelope.GHError: GHAPIModelType {
  public static func == (lhs: GHErrorEnvelope.GHError, rhs: GHErrorEnvelope.GHError) -> Bool {
    return lhs.code == rhs.code
      && lhs.field == rhs.field
      && lhs.resource == rhs.resource
  }
  public static func decode(_ json: JSON) -> Decoded<GHErrorEnvelope.GHError> {
    let creator = curry(GHErrorEnvelope.GHError.init)
    let tmp = creator
      <^> json <| "resource"
      <*> json <| "field"
      <*> json <| "code"
    return tmp
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["resource"] = self.resource
      result["field"] = self.field
    result["code"] = self.code
    return result
  }
}
















