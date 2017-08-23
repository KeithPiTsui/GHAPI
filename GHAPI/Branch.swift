//
//  Branch.swift
//  GHAPI
//
//  Created by Pi on 20/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct Branch {
  public struct BLinks {
    public let `self`: URL
    public let html: URL
  }
  public let name: String
  public let commit: Commit
  public let _links: Branch.BLinks
}
extension Branch: GHAPIModelType {
  public static func == (lhs: Branch, rhs: Branch) -> Bool {
    return lhs.name == rhs.name
      && lhs.commit == rhs.commit
      && lhs._links == rhs._links
  }
  public static func decode(_ json: JSON) -> Decoded<Branch> {
    let creator = curry(Branch.init)
    let tmp = creator
      <^> json <| "name"
      <*> json <| "commit"
    <*> json <| "_links"
    return tmp
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["name"] = self.name
    result["commit"] = self.commit.encode()
    result["_links"] = self._links.encode()
    return result
  }
}

extension Branch.BLinks: GHAPIModelType {
  public static func == (lhs: Branch.BLinks, rhs: Branch.BLinks) -> Bool {
    return lhs.`self` == rhs.`self`
  }
  public static func decode(_ json: JSON) -> Decoded<Branch.BLinks> {
    let creator = curry(Branch.BLinks.init)
    let tmp = creator
      <^> json <| "self"
      <*> json <| "html"
    return tmp
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["self"] = self.`self`.absoluteString
    result["html"] = self.html.absoluteString
    return result
  }
}
