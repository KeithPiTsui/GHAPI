//
//  PullRequest.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct PullRequest {
  public struct PNode {
    public let label: String
    public let ref: String
    public let sha: String
    public let user: UserLite
    public let repo: Repository
  }
  public struct PLinks {
    public struct PLLink {
      public let href: URL
    }
    public let `self`: PullRequest.PLinks.PLLink
    public let html: PullRequest.PLinks.PLLink
    public let issue: PullRequest.PLinks.PLLink
    public let comments: PullRequest.PLinks.PLLink
    public let review_comments: PullRequest.PLinks.PLLink
    public let review_comment: PullRequest.PLinks.PLLink
    public let commits: PullRequest.PLinks.PLLink
    public let statuses: PullRequest.PLinks.PLLink
  }
  public struct PURLs {
    public let url: URL
    public let html_url: URL
    public let diff_url: URL
    public let patch_url: URL
    public let issue_url: URL
    public let commits_url: URL
    public let review_comments_url: URL
    public let review_comment_url: URL
    public let comments_url: URL
    public let statuses_url: URL
  }
  public struct PNumbers {
    public let number: UInt
    public let comments: UInt
    public let review_comments: UInt
    public let commits: UInt
    public let additions: UInt
    public let deletions: UInt
    public let changed_files: UInt
  }
  public struct PDates {
    public let created_at: Date
    public let updated_at: Date
    public let closed_at: Date?
    public let merged_at: Date?
  }

  public let id: UInt
  public let urls: PullRequest.PURLs
  public let dates: PullRequest.PDates
  public let numbers: PullRequest.PNumbers
  public let state: String
  public let locked: Bool
  public let title: String
  public let user: UserLite
  public let body: String
  public let merge_commit_sha: String?
  public let assignee: String?
  public let milestone: String?
  public let head: PullRequest.PNode
  public let base: PullRequest.PNode
  public let _links: PullRequest.PLinks
  public let merged: Bool
  public let mergeable: Bool?
  public let mergeable_state: String
  public let merged_by: String?
}

extension PullRequest: GHAPIModelType {
  public static func == (lhs: PullRequest, rhs: PullRequest) -> Bool {
    return lhs.id == rhs.id
  }
  public static func decode(_ json: JSON) -> Decoded<PullRequest> {
    let creator = curry(PullRequest.init)
    let tmp = creator
      <^> json <| "id"
      <*> PullRequest.PURLs.decode(json)
      <*> PullRequest.PDates.decode(json)
      <*> PullRequest.PNumbers.decode(json)
    let tmp2 = tmp
      <*> json <| "state"
      <*> json <| "locked"
      <*> json <| "title"
      <*> json <| "user"
      <*> json <| "body"
      <*> json <|? "merge_commit_sha"
      <*> json <|? "assignee"
    let tmp3 = tmp2
      <*> json <|? "milestone"
      <*> json <| "head"
      <*> json <| "base"
      <*> json <| "_links"
    let tmp4 = tmp3
      <*> json <| "merged"
      <*> json <|? "mergeable"
      <*> json <| "mergeable_state"
      <*> json <|? "merged_by"
    return tmp4
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result = result.withAllValuesFrom(self.urls.encode())
    result = result.withAllValuesFrom(self.dates.encode())
    result = result.withAllValuesFrom(self.numbers.encode())
    result["id"] = self.id
    result["state"] = self.state
    result["locked"] = self.locked
    result["title"] = self.title
    result["user"] = self.user.encode()
    result["merge_commit_sha"] = self.merge_commit_sha
    result["assignee"] = self.assignee
    result["milestone"] = self.milestone
    result["head"] = self.head.encode()
    result["base"] = self.base.encode()
    result["_links"] = self._links.encode()
    result["merged"] = self.merged
    result["mergeable"] = self.mergeable
    result["mergeable_state"] = self.mergeable_state
    result["merged_by"] = self.merged_by
    return result
  }
}

extension PullRequest.PNode: GHAPIModelType {
  public static func == (lhs: PullRequest.PNode, rhs: PullRequest.PNode) -> Bool {
    return lhs.sha == rhs.sha
  }
  public static func decode(_ json: JSON) -> Decoded<PullRequest.PNode> {
    return curry(PullRequest.PNode.init)
      <^> json <| "label"
      <*> json <| "ref"
      <*> json <| "sha"
      <*> json <| "user"
      <*> json <| "repo"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["label"] = self.label
    result["ref"] = self.ref
    result["sha"] = self.sha
    result["user"] = self.user.encode()
    result["repo"] = self.repo.encode()
    return result
  }
}
extension PullRequest.PLinks.PLLink: GHAPIModelType {
  public static func == (lhs: PullRequest.PLinks.PLLink, rhs: PullRequest.PLinks.PLLink) -> Bool {
    return lhs.href == rhs.href
  }
  public static func decode(_ json: JSON) -> Decoded<PullRequest.PLinks.PLLink> {
    return curry(PullRequest.PLinks.PLLink.init)
      <^> json <| "href"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["href"] = self.href.absoluteString
    return result
  }
}

extension PullRequest.PLinks: GHAPIModelType {
  public static func == (lhs: PullRequest.PLinks, rhs: PullRequest.PLinks) -> Bool {
    return lhs.`self` == rhs.`self`
  }
  public static func decode(_ json: JSON) -> Decoded<PullRequest.PLinks> {
    return curry(PullRequest.PLinks.init)
      <^> json <| "self"
      <*> json <| "html"
      <*> json <| "issue"
      <*> json <| "comments"
      <*> json <| "review_comments"
      <*> json <| "review_comment"
      <*> json <| "commits"
      <*> json <| "statuses"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["self"] = self.`self`.encode()
    result["html"] = self.html.encode()
    result["issue"] = self.issue.encode()
    result["comments"] = self.comments.encode()
    result["review_comments"] = self.review_comments.encode()
    result["review_comment"] = self.review_comment.encode()
    result["commits"] = self.commits.encode()
    result["statuses"] = self.statuses.encode()
    return result
  }
}

extension PullRequest.PURLs: GHAPIModelType {
  public static func == (lhs: PullRequest.PURLs, rhs: PullRequest.PURLs) -> Bool {
    return lhs.url == rhs.url
  }
  public static func decode(_ json: JSON) -> Decoded<PullRequest.PURLs> {
    return curry(PullRequest.PURLs.init)
      <^> json <| "url"
      <*> json <| "html_url"
      <*> json <| "diff_url"
      <*> json <| "patch_url"
      <*> json <| "issue_url"
      <*> json <| "commits_url"
      <*> json <| "review_comments_url"
      <*> json <| "review_comment_url"
      <*> json <| "comments_url"
      <*> json <| "statuses_url"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["html_url"] = self.html_url.absoluteString
    result["diff_url"] = self.diff_url.absoluteString
    result["patch_url"] = self.patch_url.absoluteString
    result["issue_url"] = self.issue_url.absoluteString
    result["commits_url"] = self.commits_url.absoluteString
    result["review_comments_url"] = self.review_comments_url.absoluteString
    result["review_comment_url"] = self.review_comment_url.absoluteString
    result["comments_url"] = self.comments_url.absoluteString
    result["statuses_url"] = self.statuses_url.absoluteString
    return result
  }
}

extension PullRequest.PNumbers: GHAPIModelType {
  public static func == (lhs: PullRequest.PNumbers, rhs: PullRequest.PNumbers) -> Bool {
    return lhs.number == rhs.number
  }
  public static func decode(_ json: JSON) -> Decoded<PullRequest.PNumbers> {
    return curry(PullRequest.PNumbers.init)
      <^> json <| "number"
      <*> json <| "comments"
      <*> json <| "review_comments"
      <*> json <| "commits"
      <*> json <| "additions"
      <*> json <| "deletions"
      <*> json <| "changed_files"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["number"] = self.number
    result["comments"] = self.comments
    result["review_comments"] = self.review_comments
    result["commits"] = self.commits
    result["additions"] = self.additions
    result["deletions"] = self.deletions
    result["changed_files"] = self.changed_files
    return result
  }
}

extension PullRequest.PDates: GHAPIModelType {
  public static func == (lhs: PullRequest.PDates, rhs: PullRequest.PDates) -> Bool {
    return lhs.created_at == rhs.created_at
  }
  public static func decode(_ json: JSON) -> Decoded<PullRequest.PDates> {
    return curry(PullRequest.PDates.init)
      <^> json <| "created_at"
      <*> json <| "updated_at"
      <*> json <|? "closed_at"
      <*> json <|? "merged_at"
  }

  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["created_at"] = self.created_at.ISO8601DateRepresentation
    result["updated_at"] = self.updated_at.ISO8601DateRepresentation
    result["closed_at"] = self.closed_at?.ISO8601DateRepresentation
    result["merged_at"] = self.merged_at?.ISO8601DateRepresentation
    return result
  }
}
