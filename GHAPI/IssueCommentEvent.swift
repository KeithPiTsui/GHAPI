//
//  IssueCommentEvent.swift
//  GHAPI
//
//  Created by Pi on 16/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes


public struct IssueCommentEvent: EventPayloadType{
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(IssueCommentEvent.init)
      <^> json <| "action"
      <*> json <| "issue"
      <*> json <| "comment"
  }

  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["issue"] = self.issue.encode()
    result["comment"] = self.comment.encode()
    return result
  }

  public let action: String
  public let issue: IssueEventPayload.IIssue
  public let comment: IComment

  public struct IComment {
    public struct IIURLs {
      public let url: URL
      public let html_url: URL
      public let issue_url: URL
    }
    public let urls: IssueCommentEvent.IComment.IIURLs
    public let id: UInt
    public let user: User
    public let created_at: Date
    public let updated_at: Date
    public let closed_at: Date?
    public let body: String
  }

}

extension IssueCommentEvent: GHAPIModelType {
  public static func == (lhs: IssueCommentEvent, rhs: IssueCommentEvent) -> Bool {
    return lhs.action == rhs.action
      && rhs.issue == rhs.issue
      && lhs.comment == rhs.comment
  }

  public var debugDescription: String {
    return "IssueCommentEvent action:\(self.action)"
  }
}

extension IssueCommentEvent.IComment: GHAPIModelType {
  public static func == (
    lhs: IssueCommentEvent.IComment,
    rhs: IssueCommentEvent.IComment) -> Bool {
    return lhs.id == rhs.id
  }

  public var debugDescription: String {
    return "IssueEventPayload.IIssue id:\(self.id)"
  }
  public static func decode(_ json: JSON) -> Decoded<IssueCommentEvent.IComment> {
    return curry(IssueCommentEvent.IComment.init)
      <^> IssueCommentEvent.IComment.IIURLs.decode(json)
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


extension IssueCommentEvent.IComment.IIURLs: GHAPIModelType {
  public static func == (
    lhs: IssueCommentEvent.IComment.IIURLs,
    rhs: IssueCommentEvent.IComment.IIURLs) -> Bool {
    return lhs.url == rhs.url
  }

  public var debugDescription: String {
    return "IssueEventPayload.IIssue.IIURLs url:\(self.url)"
  }
  public static func decode(_ json: JSON) -> Decoded<IssueCommentEvent.IComment.IIURLs> {
    return curry(IssueCommentEvent.IComment.IIURLs.init)
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



















