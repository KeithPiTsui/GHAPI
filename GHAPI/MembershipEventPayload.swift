//
//  MembershipEventPayload.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct MembershipEventPayload: EventPayloadType{
  public let action: String
  public let scope: String
  public let member: UserLite
  public let sender: UserLite
  public let team: Team
  public let organization: Organization
}

extension MembershipEventPayload: GHAPIModelType {
  public static func == (lhs: MembershipEventPayload, rhs: MembershipEventPayload) -> Bool {
    return lhs.action == rhs.action
      && lhs.scope == rhs.scope
      && lhs.member == rhs.member
      && lhs.sender == rhs.sender
      && lhs.team == rhs.team
      && lhs.organization == rhs.organization
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(MembershipEventPayload.init)
      <^> json <| "action"
      <*> json <| "scope"
      <*> json <| "member"
      <*> json <| "sender"
      <*> json <| "team"
      <*> json <| "organization"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["scope"] = self.scope
    result["member"] = self.member.encode()
    result["sender"] = self.sender.encode()
    result["team"] = self.team.encode()
    result["organization"] = self.organization.encode()
    return result
  }
}
