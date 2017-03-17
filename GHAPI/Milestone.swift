//
//  Milestone.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct Milestone {
  public let url: URL
  public let html_url: URL
  public let labels_url: URL
  public let id: UInt
  public let number: UInt
  public let title: String
  public let desc: String?
  public let creator: UserLite
  public let open_issues: UInt
  public let closed_issues: UInt
  public let state: String
  public let created_at: Date
  public let updated_at: Date
  public let due_on: Date?
  public let closed_at: Date?
}

extension Milestone: GHAPIModelType {
  public static func == (lhs: Milestone, rhs: Milestone) -> Bool {
    return lhs.id == rhs.id
  }
  public static func decode(_ json: JSON) -> Decoded<Milestone> {
    let creator = curry(Milestone.init)
    let tmp = creator
      <^> json <| "url"
      <*> json <| "html_url"
      <*> json <| "labels_url"
      <*> json <| "id"
      <*> json <| "number"
    let tmp2 = tmp
      <*> json <| "title"
      <*> json <|? "desc"
      <*> json <| "creator"
      <*> json <| "open_issues"
      <*> json <| "closed_issues"
    let tmp3 = tmp2
      <*> json <| "state"
      <*> json <| "created_at"
      <*> json <| "updated_at"
      <*> json <|? "due_on"
      <*> json <|? "closed_at"
    return tmp3
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["html_url"] = self.html_url.absoluteString
    result["labels_url"] = self.labels_url.absoluteString
    result["id"] = self.id
    result["number"] = self.number
    result["title"] = self.title
    result["desc"] = self.desc
    result["creator"] = self.creator.encode()
    result["open_issues"] = self.open_issues
    result["closed_issues"] = self.closed_issues
    result["state"] = self.state
    result["created_at"] = self.created_at.ISO8601DateRepresentation
    result["updated_at"] = self.updated_at.ISO8601DateRepresentation
    result["due_on"] = self.due_on?.ISO8601DateRepresentation
    result["closed_at"] = self.closed_at?.ISO8601DateRepresentation
    return result
  }
}
