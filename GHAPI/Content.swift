//
//  Content.swift
//  GHAPI
//
//  Created by Pi on 20/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct Content {
  public let name: String
  public let path: String
  public let sha: String
  public let size: UInt
  public let url: URL
  public let html_url: URL
  public let git_url: URL
  public let download_url: URL
  public let type: String
  public let _links: Readme.RLinks
}

extension Content: GHAPIModelType {
  public static func == (lhs: Content, rhs: Content) -> Bool {
    return lhs.sha == rhs.sha
  }
  public static func decode(_ json: JSON) -> Decoded<Content> {
    let tmp = curry(Content.init)
      <^> json <| "name"
      <*> json <| "path"
    <*> json <| "sha"
    <*> json <| "size"
    <*> json <| "url"
    let tmp2 = tmp
    <*> json <| "html_url"
    <*> json <| "git_url"
    <*> json <| "download_url"
    <*> json <| "type"
    let tmp3 = tmp2
      <*> json <| "_links"
    return tmp3

  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["name"] = self.name
    result["path"] = self.path
    result["sha"] = self.sha
    result["size"] = self.size
    result["url"] = self.url.absoluteString
    result["html_url"] = self.html_url.absoluteString
    result["git_url"] = self.git_url.absoluteString
    result["download_url"] = self.download_url.absoluteString
    result["type"] = self.type
    result["_links"] = self._links.encode()
    return result
  }
}
