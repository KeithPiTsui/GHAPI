//
//  BranchLite.swift
//  GHAPI
//
//  Created by Pi on 11/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP



public struct BranchLite {
  public struct BCommit {
    public let sha: String
    public let url: URL
  }
  public let name: String
  public let commit: BCommit
}

extension BranchLite: GHAPIModelType {
  public static func == (lhs: BranchLite, rhs: BranchLite) -> Bool {
    return lhs.name == rhs.name && lhs.commit == rhs.commit
  }

  public static func decode(_ json: JSON) -> Decoded<BranchLite> {
    return
      curry(BranchLite.init)
        <^> json <| "name"
        <*> json <| "commit"
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["name"] = self.name
    result["commit"] = self.commit.encode()
    return result
  }
}

extension BranchLite.BCommit: GHAPIModelType {
  static public func == (lhs: BranchLite.BCommit, rhs: BranchLite.BCommit) -> Bool {
    return lhs.sha == rhs.sha
  }

  public static func decode(_ json: JSON) -> Decoded<BranchLite.BCommit> {
    let tmp = curry(BranchLite.BCommit.init)
      <^> json <| "sha"
      <*> json <| "url"
    return tmp
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["sha"] = self.sha
    result["url"] = self.url.absoluteString
    return result
  }
}



