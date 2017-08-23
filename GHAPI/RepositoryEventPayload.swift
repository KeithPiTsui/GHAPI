//
//  RepositoryEventPayload.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct RepositoryEventPayload: EventPayloadType{
  public let action: String
  public let repository: Repository
  public let organization: Organization
  public let sender: UserLite
}

extension RepositoryEventPayload: GHAPIModelType {
  public static func == (lhs: RepositoryEventPayload, rhs: RepositoryEventPayload) -> Bool {
    return lhs.action == rhs.action
      && lhs.repository == rhs.repository
      && lhs.organization == rhs.organization
      && lhs.sender == rhs.sender
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(RepositoryEventPayload.init)
      <^> json <| "action"
      <*> json <| "repository"
      <*> json <| "organization"
      <*> json <| "sender"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["organization"] = self.organization.encode()
    result["repository"] = self.repository.encode()
    result["sender"] = self.sender.encode()
    return result
  }
}
