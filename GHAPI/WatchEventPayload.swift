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
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(WatchEventPayload.init) <^> json <| "action"
  }

  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    return result
  }

  public let action: String
}

extension WatchEventPayload: GHAPIModelType {
  public static func == (lhs: WatchEventPayload, rhs: WatchEventPayload) -> Bool {
    return lhs.action == rhs.action
  }
}
