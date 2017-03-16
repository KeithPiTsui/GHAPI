//
//  IssuesEvent.swift
//  GHAPI
//
//  Created by Pi on 16/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct IssueEventPayload: EventPayloadType{
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(IssueEventPayload.init)
      <^> json <| "action"
      <*> json <| "issue"
  }

  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["issue"] = self.issue.encode()
    return result
  }

  public struct IIssue {
    public struct IIURLs {
      public let url: URL
      public let repository_url: URL
      public let labels_url: URL
      public let comments_url: URL
      public let events_url: URL
      public let html_url: URL
    }
    public let urls: IssueEventPayload.IIssue.IIURLs
    public let id: UInt
    public let number: UInt
    public let title: String
    public let user: User
    public let labels: [String]
    public let state: String
    public let locked: Bool
    public let assignee: String?
    public let assignees: [String]
    public let milestone: String?
    public let comments: UInt
    public let created_at: Date
    public let updated_at: Date
    public let closed_at: Date?
    public let body: String
  }

  public let action: String
  public let issue: IssueEventPayload.IIssue

}

extension IssueEventPayload: GHAPIModelType {
  public static func == (lhs: IssueEventPayload, rhs: IssueEventPayload) -> Bool {
    return lhs.action == rhs.action && lhs.issue == rhs.issue
  }

  public var debugDescription: String {
    return "IssueEventPayload action:\(self.action)"
  }
}

extension IssueEventPayload.IIssue: GHAPIModelType {
  public static func == (lhs: IssueEventPayload.IIssue, rhs: IssueEventPayload.IIssue) -> Bool {
    return lhs.id == rhs.id
  }

  public var debugDescription: String {
    return "IssueEventPayload.IIssue id:\(self.id)"
  }

  public static func decode(_ json: JSON) -> Decoded<IssueEventPayload.IIssue> {

    let creator = curry(IssueEventPayload.IIssue.init)
    let tmp = creator <^> IssueEventPayload.IIssue.IIURLs.decode(json)
    let tmp1 = tmp
      <*> json <| "id"
      <*> json <| "number"
      <*> json <| "title"
      <*> json <| "user"
      <*> json <|| "labels"
      <*> json <| "state"
    let tmp2 = tmp1
      <*> json <| "locked"
      <*> json <|? "assignee"
      <*> json <|| "assignees"
      <*> json <|? "milestone"
    let tmp3 = tmp2
      <*> json <| "comments"
      <*> json <| "created_at"
      <*> json <| "updated_at"
      <*> json <|? "closed_at"
      <*> json <| "body"
    return tmp3
  }

  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["id"] = self.id
    result["number"] = self.number
    result["title"] = self.title
    result["user"] = self.user.encode()
    result["labels"] = self.labels
    result["state"] = self.state
    result["locked"] = self.locked
    result["assignee"] = self.assignee
    result["assignees"] = self.assignees
    result["milestone"] = self.milestone
    result["comments"] = self.comments
    result["created_at"] = self.created_at.ISO8601DateRepresentation
    result["updated_at"] = self.updated_at.ISO8601DateRepresentation
    result["closed_at"] = self.closed_at?.ISO8601DateRepresentation
    result["body"] = self.body
    return result
  }
}

extension IssueEventPayload.IIssue.IIURLs: GHAPIModelType {
  public static func == (lhs: IssueEventPayload.IIssue.IIURLs, rhs: IssueEventPayload.IIssue.IIURLs) -> Bool {
    return lhs.url == rhs.url
  }

  public var debugDescription: String {
    return "IssueEventPayload.IIssue.IIURLs url:\(self.url)"
  }
  public static func decode(_ json: JSON) -> Decoded<IssueEventPayload.IIssue.IIURLs> {
    return curry(IssueEventPayload.IIssue.IIURLs.init)
      <^> json <| "url"
      <*> json <| "repository_url"
      <*> json <| "labels_url"
      <*> json <| "comments_url"
      <*> json <| "events_url"
      <*> json <| "html_url"
  }

  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url
    result["repository_url"] = self.repository_url
    result["labels_url"] = self.labels_url
    result["comments_url"] = self.comments_url
    result["events_url"] = self.events_url
    result["html_url"] = self.html_url
    return result
  }
}









