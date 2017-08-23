//
//  MemberEventPayload.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct MemberEventPayload: EventPayloadType{
  public let action: String
  public let member: UserLite
  public let repository: Repository?
  public let sender: UserLite?
}

extension MemberEventPayload: GHAPIModelType {
  public static func == (lhs: MemberEventPayload, rhs: MemberEventPayload) -> Bool {
    return lhs.action == rhs.action
      && lhs.member == rhs.member
      && lhs.repository == rhs.repository
      && lhs.sender == rhs.sender
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(MemberEventPayload.init)
      <^> json <| "action"
      <*> json <| "member"
    <*> json <|? "repository"
    <*> json <|? "sender"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["member"] = self.member.encode()
    result["repository"] = self.repository?.encode()
    result["sender"] = self.sender?.encode()
    return result
  }
}
