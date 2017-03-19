//
//  TeamEventPayload.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct TeamEventPayload: EventPayloadType{
  public let action: String
  public let team: Team
  public let organization: Organization
  public let sender:UserLite
}

extension TeamEventPayload: GHAPIModelType {
  public static func == (lhs: TeamEventPayload, rhs: TeamEventPayload) -> Bool {
    return lhs.action == rhs.action
      && lhs.team == rhs.team
      && lhs.organization == rhs.organization
      && lhs.sender == rhs.sender
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(TeamEventPayload.init)
      <^> json <| "action"
      <*> json <| "team"
      <*> json <| "organization"
      <*> json <| "sender"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["team"] = self.team.encode()
    result["organization"] = self.organization.encode()
    result["sender"] = self.sender.encode()
    return result
  }
}
