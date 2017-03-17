//
//  Readme.swift
//  GHAPI
//
//  Created by Pi on 13/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes


public struct Readme {
  public struct RLinks {
    public let `self`: URL
    public let git: URL
    public let html: URL
  }

  public let name: String
  public let path: String
  public let sha: String
  public let size: UInt
  public let url: URL
  public let html_url: URL
  public let git_url: URL
  public let download_url: URL
  public let type: String
  public let content: String
  public let encoding: String
  public let _links: RLinks
}

extension Readme: GHAPIModelType{
  public static func == (lhs: Readme, rhs: Readme) -> Bool {
    return lhs.sha == rhs.sha
  }

  public static func decode(_ json: JSON) -> Decoded<Readme> {
    let creator = curry(Readme.init)
    let tmp = creator
      <^> json <| "name"
      <*> json <| "path"
      <*> json <| "sha"
      <*> json <| "size"
      <*> json <| "url"
    let tmp1 = tmp
      <*> json <| "html_url"
      <*> json <| "git_url"
      <*> json <| "download_url"
      <*> json <| "type"
    let tmp2 = tmp1
      <*> json <| "content"
      <*> json <| "encoding"
    return tmp2
      <*> json <| "_links"
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["name"] = self.name
    result["path"] = self.path
    result["size"] = self.size
    result["url"] = self.url.absoluteString
    result["html_url"] = self.html_url.absoluteString
    result["git_url"] = self.git_url.absoluteString
    result["download_url"] = self.download_url.absoluteString
    result["type"] = self.type
    result["content"] = self.content
    result["encoding"] = self.encoding
    result["_links"] = self._links.encode()
    return result
  }
}
extension Readme.RLinks: GHAPIModelType {
  public static func == (lhs: Readme.RLinks, rhs: Readme.RLinks) -> Bool {
    return lhs.git == rhs.git
  }

  public static func decode(_ json: JSON) -> Decoded<Readme.RLinks> {
    let creator = curry(Readme.RLinks.init)
    let tmp = creator
      <^> json <| "self"
      <*> json <| "git"
      <*> json <| "html"
    return tmp
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["self"] = self.`self`.absoluteString
    result["git"] = self.git.absoluteString
    result["html"] = self.html.absoluteString
    return result
  }
}
































