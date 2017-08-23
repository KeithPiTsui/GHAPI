//
//  IssuesEvent.swift
//  GHAPI
//
//  Created by Pi on 16/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct IssueEventPayload: EventPayloadType{
  public let action: String
  public let issue: Issue
}

extension IssueEventPayload: GHAPIModelType {
  public static func == (lhs: IssueEventPayload, rhs: IssueEventPayload) -> Bool {
    return lhs.action == rhs.action && lhs.issue == rhs.issue
  }
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
}








