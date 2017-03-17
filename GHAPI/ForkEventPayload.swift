//
//  ForkEventPayload.swift
//  GHAPI
//
//  Created by Pi on 13/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes


public struct ForkEventPayload: EventPayloadType {
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(ForkEventPayload.init)
      <^> json <| "forkee"
      <*> json <|? "repository"
      <*> json <|? "sender"

  }

  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["forkee"] = self.forkee.encode()
    result["repository"] = self.repository?.encode()
    result["sender"] = self.sender?.encode()
    return result
  }

  public let forkee: Repository
  public let repository: Repository?
  public let sender: User?
}

extension ForkEventPayload: GHAPIModelType {
  public static func == (lhs: ForkEventPayload, rhs: ForkEventPayload) -> Bool {
    return lhs.forkee == rhs.forkee && lhs.repository == rhs.repository && lhs.sender == rhs.sender
  }
}
