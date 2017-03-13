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
        switch json {
        case .object(let payload):
            guard let payloadJson = payload["payload"] else { break }
            return curry(WatchEventPayload.init) <^> payloadJson <| "action"
        default:
            break
        }
        return .failure(.custom("WatchEventPayload cannot be constructed from Json \(json)"))
    }
    
    public func encode() -> [String : Any] {
        var result: [String:Any] = [:]
        result["action"] = self.action
        return result
    }
    
    public let action: String
}
