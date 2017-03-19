//
//  PullRequestEventPayload.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct PullRequestEventPayload: EventPayloadType{
  public struct PInstallation {
    public let id: UInt
  }
  public let action: String
  public let number: UInt
  public let pull_request: PullRequest
  public let repository: Repository?
  public let sender: UserLite?
  public let installation: PullRequestEventPayload.PInstallation?
}

extension PullRequestEventPayload: GHAPIModelType {
  public static func == (lhs: PullRequestEventPayload, rhs: PullRequestEventPayload) -> Bool {
    return lhs.action == rhs.action
      && lhs.number == rhs.number
      && lhs.pull_request == rhs.pull_request
      && lhs.repository == rhs.repository
      && lhs.sender == rhs.sender
      && lhs.installation == rhs.installation
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(PullRequestEventPayload.init)
      <^> json <| "action"
      <*> json <| "number"
      <*> json <| "pull_request"
      <*> json <|? "repository"
      <*> json <|? "sender"
      <*> json <|? "installation"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["number"] = self.number
    result["pull_request"] = self.pull_request.encode()
    result["repository"] = self.repository?.encode()
    result["sender"] = self.sender?.encode()
    result["installation"] = self.installation?.encode()
    return result
  }
}

extension PullRequestEventPayload.PInstallation: GHAPIModelType {
  public static func == (lhs: PullRequestEventPayload.PInstallation, rhs: PullRequestEventPayload.PInstallation) -> Bool {
    return lhs.id == rhs.id
  }
  public static func decode(_ json: JSON) -> Decoded<PullRequestEventPayload.PInstallation> {
    return curry(PullRequestEventPayload.PInstallation.init)
      <^> json <| "id"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["id"] = self.id
    return result
  }
}
