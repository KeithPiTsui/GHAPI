//
//  MilestoneEventPayload.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct MilestoneEventPayload: EventPayloadType{
  public let action: String
  public let milestone: Milestone
  public let repository: Repository
  public let organization: Organization
  public let sender: UserLite

}

extension MilestoneEventPayload: GHAPIModelType {
  public static func == (lhs: MilestoneEventPayload, rhs: MilestoneEventPayload) -> Bool {
    return lhs.action == rhs.action
      && lhs.milestone == rhs.milestone
      && lhs.repository == rhs.repository
      && lhs.organization == rhs.organization
      && lhs.sender == rhs.sender
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(MilestoneEventPayload.init)
      <^> json <| "action"
      <*> json <| "milestone"
      <*> json <| "repository"
      <*> json <| "organization"
      <*> json <| "sender"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["milestone"] = self.milestone.encode()
    result["repository"] = self.repository.encode()
    result["organization"] = self.organization.encode()
    result["sender"] = self.sender.encode()
    return result
  }
}
