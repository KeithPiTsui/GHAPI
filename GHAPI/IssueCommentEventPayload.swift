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
  public let comment: IssueComment
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











