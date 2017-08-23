//
//  PaginationLinks.swift
//  GHAPI
//
//  Created by Pi on 11/04/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP

import Foundation

public struct PaginationLinks {
  public let next: URL?
  public let last: URL?
  public let first: URL?
  public let prev: URL?
}

extension PaginationLinks: GHAPIModelType {
  public static func == (lhs: PaginationLinks, rhs: PaginationLinks) -> Bool {
    return lhs.next == rhs.next
      && lhs.last == rhs.last
      && lhs.first == rhs.first
      && lhs.prev == rhs.prev
  }
  public static func decode(_ json: JSON) -> Decoded<PaginationLinks> {
    let creator = curry(PaginationLinks.init)
    let tmp = creator
      <^> json <|? "next"
      <*> json <|? "last"
      <*> json <|? "first"
      <*> json <|? "prev"
    return tmp
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["next"] = self.next?.absoluteString
    result["last"] = self.last?.absoluteString
    result["first"] = self.first?.absoluteString
    result["prev"] = self.prev?.absoluteString
    return result
  }
}

extension PaginationLinks {
  init?(_ response: HTTPURLResponse) {
    /**
     <https://api.github.com/user/12403137/received_events?page=4&per_page=2>; rel="next",
     <https://api.github.com/user/12403137/received_events?page=150&per_page=2>; rel="last",
     <https://api.github.com/user/12403137/received_events?page=1&per_page=2>; rel="first",
     <https://api.github.com/user/12403137/received_events?page=2&per_page=2>; rel="prev"
     Conditionally inject links into json
     */
    let headers = response.allHeaderFields
    guard
      let linksStr = headers["Link"] as? String,
      let linkPattern = try? NSRegularExpression(pattern: "<.*>", options: []),
      let linkNamePattern = try? NSRegularExpression(pattern: "rel=\".*\"", options: [])
      else { return nil }

    let linkComponents = linksStr.components(separatedBy: ",")
    var dict = [String: String]()
    linkComponents
      .forEach{ (orgStr) in
        let nsOrgStr = orgStr as NSString

        let linkRange = linkPattern.rangeOfFirstMatch(in: orgStr,
                                                      options: [],
                                                      range: NSRange(location: 0, length: nsOrgStr.length))
        if linkRange.location == NSNotFound { return }
        let link = nsOrgStr.substring(with: linkRange).trimmingCharacters(in: CharacterSet(charactersIn: "<>"))

        let linkNameRange = linkNamePattern.rangeOfFirstMatch(in: orgStr,
                                                              options: [],
                                                              range: NSRange(location: 0, length: nsOrgStr.length))
        if linkNameRange.location == NSNotFound { return }
        guard let linkName = nsOrgStr
          .substring(with: linkNameRange)
          .components(separatedBy: "=").last?
          .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
          else { return }
        dict[linkName] = link
    }
    guard dict.isEmpty == false else { return nil }
    let json = JSON.init(dict)
    guard let links = PaginationLinks.decode(json).value else { return nil }
    self = links
  }
}









