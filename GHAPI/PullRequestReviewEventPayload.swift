//
//  PullRequestReviewEventPayload.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct PullRequestReviewEventPayload: EventPayloadType{
  public struct PReview {
    public struct PRLinks {
      public let html: PullRequest.PLinks.PLLink
      public let pull_request: PullRequest.PLinks.PLLink
    }

    public let id: UInt
    public let user: UserLite
    public let body: String
    public let submitted_at: Date
    public let state: String
    public let html_url: URL
    public let pull_request_url: URL
    public let _links: PullRequestReviewEventPayload.PReview.PRLinks
  }
  public let action: String
  public let review: PullRequestReviewEventPayload.PReview
  public let pull_request: PullRequest
  public let repository: Repository
  public let sender: UserLite
}
extension PullRequestReviewEventPayload: GHAPIModelType {
  public static func == (lhs: PullRequestReviewEventPayload, rhs: PullRequestReviewEventPayload) -> Bool {
    return lhs.action == rhs.action
      && lhs.review == rhs.review
      && lhs.pull_request == rhs.pull_request
      && lhs.repository == rhs.repository
      && lhs.sender == rhs.sender
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(PullRequestReviewEventPayload.init)
      <^> json <| "action"
      <*> json <| "review"
      <*> json <| "pull_request"
      <*> json <| "repository"
      <*> json <| "sender"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["review"] = self.review.encode()
    result["pull_request"] = self.pull_request.encode()
    result["repository"] = self.repository.encode()
    result["sender"] = self.sender.encode()
    return result
  }
}

extension PullRequestReviewEventPayload.PReview: GHAPIModelType {
  public static func == (lhs: PullRequestReviewEventPayload.PReview, rhs: PullRequestReviewEventPayload.PReview)
    -> Bool {
      return lhs.id == rhs.id
  }
  public static func decode(_ json: JSON) -> Decoded<PullRequestReviewEventPayload.PReview> {
    return curry(PullRequestReviewEventPayload.PReview.init)
      <^> json <| "id"
      <*> json <| "user"
      <*> json <| "body"
      <*> json <| "submitted_at"
      <*> json <| "state"
      <*> json <| "html_url"
      <*> json <| "pull_request_url"
      <*> json <| "_links"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["id"] = self.id
    result["user"] = self.user.encode()
    result["body"] = self.body
    result["submitted_at"] = self.submitted_at.ISO8601DateRepresentation
    result["state"] = self.state
    result["html_url"] = self.html_url.absoluteString
    result["pull_request_url"] = self.pull_request_url.absoluteString
    result["_links"] = self._links.encode()
    return result
  }
}
extension PullRequestReviewEventPayload.PReview.PRLinks: GHAPIModelType {
  public static func == (
    lhs: PullRequestReviewEventPayload.PReview.PRLinks,
    rhs: PullRequestReviewEventPayload.PReview.PRLinks)
    -> Bool {
      return lhs.html == rhs.html
  }
  public static func decode(_ json: JSON) -> Decoded<PullRequestReviewEventPayload.PReview.PRLinks> {
    return curry(PullRequestReviewEventPayload.PReview.PRLinks.init)
      <^> json <| "html"
      <*> json <| "pull_request"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["html"] = self.html.encode()
    result["pull_request"] = self.pull_request.encode()
    return result
  }
}
