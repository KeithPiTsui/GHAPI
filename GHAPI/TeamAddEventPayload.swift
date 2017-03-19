//
//  TeamAddEventPayload.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct TeamAddEventPayload: EventPayloadType{
  public let team: Team
  public let repository: Repository
  public let organization: Organization
  public let sender: UserLite

}

extension TeamAddEventPayload: GHAPIModelType {
  public static func == (lhs: TeamAddEventPayload, rhs: TeamAddEventPayload) -> Bool {
    return lhs.team == rhs.team
      && lhs.repository == rhs.repository
      && lhs.organization == rhs.organization
      && lhs.sender == rhs.sender
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(TeamAddEventPayload.init)
      <^> json <| "team"
      <*> json <| "repository"
    <*> json <| "organization"
    <*> json <| "sender"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["team"] = self.team.encode()
    result["repository"] = self.repository.encode()
    result["organization"] = self.organization.encode()
    result["sender"] = self.sender.encode()
    return result
  }
}
