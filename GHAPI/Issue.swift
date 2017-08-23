//
//  Issue.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct Issue {
  public struct IURLs {
    public let url: URL
    public let repository_url: URL?
    public let labels_url: URL
    public let comments_url: URL
    public let events_url: URL
    public let html_url: URL
  }
  public struct ILabel {
    public let id: UInt
    public let url: URL
    public let name: String
    public let color: String
    public let `default`: Bool
  }
  public let urls: Issue.IURLs
  public let id: UInt
  public let number: UInt
  public let title: String
  public let user: User
  public let labels: [ILabel]
  public let state: String
  public let locked: Bool
  public let assignee: UserLite?
  public let assignees: [UserLite]?
  public let milestone: Milestone?
  public let comments: UInt
  public let created_at: Date
  public let updated_at: Date
  public let closed_at: Date?
  public let body: String
  public let pull_request: PullRequestLite?
}

extension Issue: GHAPIModelType {
  public static func == (lhs: Issue, rhs: Issue) -> Bool {
    return lhs.id == rhs.id
  }

  public static func decode(_ json: JSON) -> Decoded<Issue> {

    let creator = curry(Issue.init)
    let tmp = creator <^> Issue.IURLs.decode(json)
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
      <*> json <||? "assignees"
      <*> json <|? "milestone"
    let tmp3 = tmp2
      <*> json <| "comments"
      <*> json <| "created_at"
      <*> json <| "updated_at"
      <*> json <|? "closed_at"
      <*> json <| "body"
      <*> json <|? "pull_request"
    return tmp3
  }

  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["id"] = self.id
    result["number"] = self.number
    result["title"] = self.title
    result["user"] = self.user.encode()
    result["labels"] = self.labels.map{$0.encode()}
    result["state"] = self.state
    result["locked"] = self.locked
    result["assignee"] = self.assignee?.encode()
    result["assignees"] = self.assignees?.map{$0.encode()}
    result["milestone"] = self.milestone?.encode()
    result["comments"] = self.comments
    result["created_at"] = self.created_at.ISO8601DateRepresentation
    result["updated_at"] = self.updated_at.ISO8601DateRepresentation
    result["closed_at"] = self.closed_at?.ISO8601DateRepresentation
    result["body"] = self.body
    result["pull_request"] = self.pull_request?.encode()
    return result
  }
}

extension Issue.IURLs: GHAPIModelType {
  public static func == (lhs: Issue.IURLs, rhs: Issue.IURLs) -> Bool {
    return lhs.url == rhs.url
  }
  public static func decode(_ json: JSON) -> Decoded<Issue.IURLs> {
    return curry(Issue.IURLs.init)
      <^> json <| "url"
      <*> json <|? "repository_url"
      <*> json <| "labels_url"
      <*> json <| "comments_url"
      <*> json <| "events_url"
      <*> json <| "html_url"
  }

  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["repository_url"] = self.repository_url?.absoluteString
    result["labels_url"] = self.labels_url.absoluteString
    result["comments_url"] = self.comments_url.absoluteString
    result["events_url"] = self.events_url.absoluteString
    result["html_url"] = self.html_url.absoluteString
    return result
  }
}

extension Issue.ILabel: GHAPIModelType {
  public static func == (lhs: Issue.ILabel, rhs: Issue.ILabel) -> Bool {
    return lhs.id == rhs.id
  }
  public static func decode(_ json: JSON) -> Decoded<Issue.ILabel> {
    let creator = curry(Issue.ILabel.init)
    let tmp = creator
      <^> json <| "id"
      <*> json <| "url"
      <*> json <| "name"
    let tmp2 = tmp
      <*> json <| "color"
      <*> json <| "default"
    return tmp2
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["id"] = self.id
    result["url"] = self.url.absoluteString
    result["name"] = self.name
    result["color"] = self.color
    result["default"] = self.`default`
    return result
  }
}

