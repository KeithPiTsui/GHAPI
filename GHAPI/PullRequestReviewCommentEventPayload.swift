//
//  PullRequestReviewCommentEventPayload.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct PullRequestReviewCommentEventPayload: EventPayloadType{
  public struct PComment {
    public struct PCLinks {
      public let `self`: PullRequest.PLinks.PLLink
      public let html: PullRequest.PLinks.PLLink
      public let pull_request: PullRequest.PLinks.PLLink
    }
    public let url: URL
    public let id: UInt
    public let diff_hunk: String
    public let path: String
    public let position: UInt?
    public let original_position: UInt
    public let commit_id: String
    public let original_commit_id: String
    public let user: UserLite
    public let body: String
    public let created_at: Date
    public let updated_at: Date
    public let html_url: URL
    public let pull_request_url: URL
    public let _links: PullRequestReviewCommentEventPayload.PComment.PCLinks
  }
  public let action: String
  public let comment: PullRequestReviewCommentEventPayload.PComment
  public let pull_request: PullRequest
  public let repository: Repository?
  public let sender: UserLite?
}
extension PullRequestReviewCommentEventPayload: GHAPIModelType {
  public static func == (lhs: PullRequestReviewCommentEventPayload, rhs: PullRequestReviewCommentEventPayload) -> Bool {
    return lhs.action == rhs.action
      && lhs.comment == rhs.comment
      && lhs.pull_request == rhs.pull_request
      && lhs.repository == rhs.repository
      && lhs.sender == rhs.sender
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(PullRequestReviewCommentEventPayload.init)
      <^> json <| "action"
      <*> json <| "comment"
      <*> json <| "pull_request"
      <*> json <|? "repository"
      <*> json <|? "sender"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["comment"] = self.comment.encode()
    result["pull_request"] = self.pull_request.encode()
    result["repository"] = self.repository?.encode()
    result["sender"] = self.sender?.encode()
    return result
  }
}

extension PullRequestReviewCommentEventPayload.PComment: GHAPIModelType {
  public static func == (lhs: PullRequestReviewCommentEventPayload.PComment, rhs: PullRequestReviewCommentEventPayload.PComment)
    -> Bool {
      return lhs.id == rhs.id
  }
  public static func decode(_ json: JSON) -> Decoded<PullRequestReviewCommentEventPayload.PComment> {
    let tmp = curry(PullRequestReviewCommentEventPayload.PComment.init)
      <^> json <| "url"
      <*> json <| "id"
      <*> json <| "diff_hunk"
      <*> json <| "path"
      <*> json <|? "position"
      <*> json <| "original_position"
      <*> json <| "commit_id"
      <*> json <| "original_commit_id"
    let tmp2 = tmp
      <*> json <| "user"
    <*> json <| "body"
    <*> json <| "created_at"
    <*> json <| "updated_at"
    <*> json <| "html_url"
    let tmp3 = tmp2
      <*> json <| "pull_request_url"
      <*> json <| "_links"
    return tmp3
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["id"] = self.id
    result["diff_hunk"] = self.diff_hunk
    result["path"] = self.path
    result["position"] = self.position
    result["original_position"] = self.original_position
    result["commit_id"] = self.commit_id
    result["original_commit_id"] = self.original_commit_id
    result["user"] = self.user.encode()
    result["body"] = self.body
    result["created_at"] = self.created_at.ISO8601DateRepresentation
    result["updated_at"] = self.updated_at.ISO8601DateRepresentation
    result["html_url"] = self.html_url.absoluteString
    result["pull_request_url"] = self.pull_request_url.absoluteString
    result["_links"] = self._links.encode()
    return result
  }
}
extension PullRequestReviewCommentEventPayload.PComment.PCLinks: GHAPIModelType {
  public static func == (
    lhs: PullRequestReviewCommentEventPayload.PComment.PCLinks,
    rhs: PullRequestReviewCommentEventPayload.PComment.PCLinks)
    -> Bool {
      return lhs.html == rhs.html
  }
  public static func decode(_ json: JSON) -> Decoded<PullRequestReviewCommentEventPayload.PComment.PCLinks> {
    return curry(PullRequestReviewCommentEventPayload.PComment.PCLinks.init)
      <^> json <| "self"
      <*> json <| "html"
      <*> json <| "pull_request"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["self"] = self.`self`.encode()
    result["html"] = self.html.encode()
    result["pull_request"] = self.pull_request.encode()
    return result
  }
}

