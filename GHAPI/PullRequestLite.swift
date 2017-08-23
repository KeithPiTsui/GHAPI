//
//  PullRequestLite.swift
//  GHAPI
//
//  Created by Pi on 03/04/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP

public struct PullRequestLite {
  public let url: URL
  public let html_url: URL
  public let diff_url: URL
  public let patch_url: URL
}


extension PullRequestLite: GHAPIModelType {
  public static func == (lhs: PullRequestLite, rhs: PullRequestLite) -> Bool {
    return lhs.url == rhs.url
  }
  public static func decode(_ json: JSON) -> Decoded<PullRequestLite> {
    let creator = curry(PullRequestLite.init)
    let tmp = creator
      <^> json <| "url"
      <*> json <| "html_url"
    <*> json <| "diff_url"
    <*> json <| "patch_url"
    return tmp
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["html_url"] = self.html_url.absoluteString
    result["diff_url"] = self.diff_url.absoluteString
    result["patch_url"] = self.patch_url.absoluteString
    return result
  }
}
