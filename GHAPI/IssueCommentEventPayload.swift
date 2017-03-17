//
//  IssueCommentEventPayload.swift
//  GHAPI
//
//  Created by Pi on 16/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes


public struct IssueCommentEventPayload: EventPayloadType{
  public let action: String
  public let issue: Issue
  public let comment: IComment

  public struct IComment {
    public struct IIURLs {
      public let url: URL
      public let html_url: URL
      public let issue_url: URL
    }
    public let urls: IssueCommentEventPayload.IComment.IIURLs
    public let id: UInt
    public let user: User
    public let created_at: Date
    public let updated_at: Date
    public let closed_at: Date?
    public let body: String
  }

}

extension IssueCommentEventPayload: GHAPIModelType {
  public static func == (lhs: IssueCommentEventPayload, rhs: IssueCommentEventPayload) -> Bool {
    return lhs.action == rhs.action
      && rhs.issue == rhs.issue
      && lhs.comment == rhs.comment
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(IssueCommentEventPayload.init)
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
}

extension IssueCommentEventPayload.IComment: GHAPIModelType {
  public static func == (
    lhs: IssueCommentEventPayload.IComment,
    rhs: IssueCommentEventPayload.IComment) -> Bool {
    return lhs.id == rhs.id
  }

  public static func decode(_ json: JSON) -> Decoded<IssueCommentEventPayload.IComment> {
    return curry(IssueCommentEventPayload.IComment.init)
      <^> IssueCommentEventPayload.IComment.IIURLs.decode(json)
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


extension IssueCommentEventPayload.IComment.IIURLs: GHAPIModelType {
  public static func == (
    lhs: IssueCommentEventPayload.IComment.IIURLs,
    rhs: IssueCommentEventPayload.IComment.IIURLs) -> Bool {
    return lhs.url == rhs.url
  }

  public static func decode(_ json: JSON) -> Decoded<IssueCommentEventPayload.IComment.IIURLs> {
    return curry(IssueCommentEventPayload.IComment.IIURLs.init)
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



















