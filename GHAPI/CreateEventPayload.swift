//
//  CreateEventPayload.swift
//  GHAPI
//
//  Created by Pi on 13/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct CreateEventPayload: EventPayloadType{
    public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
        switch json {
        case .object(let payload):
            guard let payloadJson = payload["payload"] else { break }
            return curry(CreateEventPayload.init)
                <^> payloadJson <|? "ref"
                <*> payloadJson <| "ref_type"
                <*> payloadJson <| "master_branch"
                <*> payloadJson <|? "description"
                <*> payloadJson <| "pusher_type"
                <*> payloadJson <|? "repostiory"
                <*> payloadJson <|? "sender"
        default:
            break
        }
        return .failure(.custom("WatchEventPayload cannot be constructed from Json \(json)"))
    }
    
    public func encode() -> [String : Any] {
        var result: [String:Any] = [:]
        result["ref"] = self.ref
        result["ref_type"] = self.ref_type
        result["master_branch"] = self.master_branch
        result["description"] = self.desc
        result["pusher_type"] = self.pusher_type
        return result
    }
    
    public let ref: String?
    public let ref_type: String
    public let master_branch: String
    public let desc: String?
    public let pusher_type: String
    public let repostiory: Repository?
    public let sender: User?
}

extension CreateEventPayload: GHAPIModelType {
    public static func == (lhs: CreateEventPayload, rhs: CreateEventPayload) -> Bool {
        return lhs.ref == rhs.ref
    }
    
    public var debugDescription: String {
        return "CreateEventPayload ref:\(self.ref)"
    }
}
