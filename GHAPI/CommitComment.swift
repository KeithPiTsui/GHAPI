//
//  CommitComment.swift
//  GHAPI
//
//  Created by Pi on 30/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct CommitComment {
  public let url: URL
  public let html_url: URL
  public let id: UInt
  public let user: User
  public let position: String?
  public let line: UInt?
  public let path: String?
  public let commit_id: String
  public let created_at: Date
  public let updated_at: Date
  public let body: String
}

extension CommitComment: GHAPIModelType {
  public static func == (
    lhs: CommitComment,
    rhs: CommitComment) -> Bool {
    return lhs.id == rhs.id
  }

  public static func decode(_ json: JSON) -> Decoded<CommitComment> {
    let creator = curry(CommitComment.init)
      <^> json <| "url"
      <*> json <| "html_url"
    let tmp = creator
      <*> json <| "id"
      <*> json <| "user"
      <*> json <|? "position"
      <*> json <|? "line"
    let tmp2 = tmp
      <*> json <|? "path"
      <*> json <| "commit_id"
      <*> json <| "created_at"
      <*> json <| "updated_at"
      <*> json <| "body"
    return tmp2
  }

  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["html_url"] = self.html_url.absoluteString
    result["id"] = self.id
    result["user"] = self.user.encode()
    result["position"] = self.position
    result["line"] = self.line
    result["path"] = self.path
    result["commit_id"] = self.commit_id
    result["created_at"] = self.created_at.ISO8601DateRepresentation
    result["updated_at"] = self.updated_at.ISO8601DateRepresentation
    result["body"] = self.body
    return result
  }
}
