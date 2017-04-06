//
//  WatchEventPayload.swift
//  GHAPI
//
//  Created by Pi on 13/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct WatchEventPayload: EventPayloadType{
  public let action: String
  public let repository: Repository
  public let sender: UserLite
}

extension WatchEventPayload: GHAPIModelType {
  public static func == (lhs: WatchEventPayload, rhs: WatchEventPayload) -> Bool {
    return lhs.action == rhs.action
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(WatchEventPayload.init)
      <^> json <| "action"
      <*> json <| "repository"
    <*> json <| "sender"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["repository"] = self.repository.encode()
    result["sender"] = self.sender.encode()
    return result
  }
}
