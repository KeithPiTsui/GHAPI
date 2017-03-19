//
//  OrgBlockEventPayload.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct OrgBlockEventPayload: EventPayloadType{
  public let action: String
  public let blocked_user: UserLite
  public let organization: Organization
  public let sender: UserLite
}

extension OrgBlockEventPayload: GHAPIModelType {
  public static func == (lhs: OrgBlockEventPayload, rhs: OrgBlockEventPayload) -> Bool {
    return lhs.action == rhs.action
      && lhs.blocked_user == rhs.blocked_user
      && lhs.organization == rhs.organization
      && lhs.sender == rhs.sender
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(OrgBlockEventPayload.init)
      <^> json <| "action"
      <*> json <| "blocked_user"
      <*> json <| "organization"
      <*> json <| "sender"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["blocked_user"] = self.blocked_user.encode()
    result["organization"] = self.organization.encode()
    result["sender"] = self.sender.encode()
    return result
  }
}
