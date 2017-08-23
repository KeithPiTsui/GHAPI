//
//  PublicEventPayload.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct PublicEventPayload: EventPayloadType{
  public let repository: Repository
  public let sender: UserLite
}

extension PublicEventPayload: GHAPIModelType {
  public static func == (lhs: PublicEventPayload, rhs: PublicEventPayload) -> Bool {
    return lhs.repository == rhs.repository
      && lhs.sender == rhs.sender
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(PublicEventPayload.init)
      <^> json <| "repository"
      <*> json <| "sender"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["repository"] = self.repository.encode()
    result["sender"] = self.sender.encode()
    return result
  }
}
