//
//  Events.swift
//  GHAPI
//
//  Created by Pi on 13/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//


import Argo
import Curry
import Runes

public enum EventType: String {
    case CommitCommentEvent
    case CreateEvent
    case WatchEvent
}
extension EventType: GHAPIModelType {
    public var debugDescription: String {
        return "Event.EIndividual id: \(self.rawValue) "
    }
    
    public static func decode(_ json: JSON) -> Decoded<EventType> {
        switch json {
        case .string(let typeStr):
            guard let et = EventType.init(rawValue: typeStr) else {
                return .failure(.custom("EventType string misformatted"))
            }
            return pure(et)
        default: return .typeMismatch(expected: "EventType", actual: json)
        }
    }
    public func encode() -> [String:Any] {
        var result: [String:Any] = [:]
        result["type"] = self.rawValue
        return result
    }
}

public struct EIndividual {
    public let id: UInt
    public let login: String
    public let gravatar_id: String
    public let avatar_url: URL
    public let url: URL
}
extension EIndividual: GHAPIModelType {
    public static func == (lhs: EIndividual, rhs: EIndividual) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var debugDescription: String {
        return "Event.EIndividual id: \(self.id) "
    }
    
    public static func decode(_ json: JSON) -> Decoded<EIndividual> {
        let creator = curry(EIndividual.init)
        let tmp = creator
            <^> json <| "id"
            <*> json <| "login"
            <*> json <| "gravatar_id"
            <*> json <| "avatar_url"
            <*> json <| "url"
        return tmp
    }
    public func encode() -> [String:Any] {
        var result: [String:Any] = [:]
        result["id"] = self.id
        result["login"] = self.login
        result["gravatar_id"] = self.gravatar_id
        result["url"] = self.url.absoluteString
        result["avatar_url"] = self.avatar_url.absoluteString
        return result
    }
}

public protocol EventPayloadType {
    static func decode(_ json: JSON) -> Decoded<EventPayloadType>
}

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
    
    public let action: String
}


public struct GHEvent {
    public let type: EventType
    public let `public`: Bool
    public let actor: EIndividual
    public let org: EIndividual?
    public let created_at: Date
    public let id: String
    public let payload: EventPayloadType?
}

fileprivate let payloadConstructorDict: [EventType: EventPayloadType.Type] =
    [EventType.WatchEvent: WatchEventPayload.self]


extension GHEvent: Decodable {
    public static func decode(_ json: JSON) -> Decoded<GHEvent> {
        let creator = curry(GHEvent.init)
        let tmp = creator <^> json <| "type"
            <*> json <| "public"
            <*> json <| "actor"
            <*> json <|? "org"
            <*> json <| "created_at"
            <*> json <| "id"
        
        var _payload: Decoded<EventPayloadType>? = nil
        
        let t: Decoded<EventType> = json <| "type"
        if let tt = t.value {
            _payload = payloadConstructorDict[tt]?.decode(json)
        }
        
        let payload: Decoded<EventPayloadType?>
        if let pl = _payload {
            payload = pl.map(Optional.some)
        } else {
            payload = Decoded<EventPayloadType?>.success(nil)
        }
        let tmp5 = tmp <*> payload
        return tmp5
    }
}










































