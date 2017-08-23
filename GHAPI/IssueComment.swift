//
//  IssueComment.swift
//  GHAPI
//
//  Created by Pi on 24/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct IssueComment {
  public struct IIURLs {
    public let url: URL
    public let html_url: URL
    public let issue_url: URL
  }
  public let urls: IssueComment.IIURLs
  public let id: UInt
  public let user: User
  public let created_at: Date
  public let updated_at: Date
  public let closed_at: Date?
  public let body: String
}

extension  IssueComment: GHAPIModelType {
  public static func == (
    lhs:  IssueComment,
    rhs:  IssueComment) -> Bool {
    return lhs.id == rhs.id
  }

  public static func decode(_ json: JSON) -> Decoded<IssueComment> {
    return curry(IssueComment.init)
      <^>  IssueComment.IIURLs.decode(json)
      <*> json <| "id"
      <*> json <| "user"
      <*> json <| "created_at"
      <*> json <| "updated_at"
      <*> json <|? "closed_at"
      <*> json <| "body"
  }

  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result = result.withAllValuesFrom(self.urls.encode())
    result["id"] = self.id
    result["user"] = self.user.encode()
    result["created_at"] = self.created_at.ISO8601DateRepresentation
    result["updated_at"] = self.updated_at.ISO8601DateRepresentation
    result["closed_at"] = self.closed_at?.ISO8601DateRepresentation
    result["body"] = self.body
    return result
  }
}


extension  IssueComment.IIURLs: GHAPIModelType {
  public static func == (
    lhs:  IssueComment.IIURLs,
    rhs:  IssueComment.IIURLs) -> Bool {
    return lhs.url == rhs.url
  }

  public static func decode(_ json: JSON) -> Decoded<IssueComment.IIURLs> {
    return curry(IssueComment.IIURLs.init)
      <^> json <| "url"
      <*> json <| "html_url"
      <*> json <| "issue_url"
  }

  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["issue_url"] = self.issue_url.absoluteString
    result["html_url"] = self.html_url.absoluteString
    return result
  }
}
