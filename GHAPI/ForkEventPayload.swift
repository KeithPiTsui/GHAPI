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
        switch json {
        case .object(let payload):
            guard let payloadJson = payload["payload"] else { break }
            return curry(ForkEventPayload.init)
                <^> payloadJson <| "forkee"
                <*> payloadJson <| "repository"
                <*> payloadJson <| "sender"
        default:
            break
        }
        return .failure(.custom("ForkEventPayload cannot be constructed from Json \(json)"))
    }
    
    public func encode() -> [String : Any] {
        var result: [String:Any] = [:]
        result["forkee"] = self.forkee.encode()
        result["repository"] = self.repository.encode()
        result["sender"] = self.sender.encode()
        return result
    }
    
    public let forkee: Repository
    public let repository: Repository
    public let sender: User
}
