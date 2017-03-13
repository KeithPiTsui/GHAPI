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

public struct GHEvent {
    public enum EventType: String {
        case CommitCommentEvent
        case CreateEvent
        case WatchEvent
    }
    public struct EIndividual {
        public let id: UInt
        public let login: String
        public let gravatar_id: String
        public let avatar_url: URL
        public let url: URL
    }
    public struct ERepository {
        public let id: UInt
        public let name: String
        public let url: URL
    }
    
    public let type: GHEvent.EventType
    public let `public`: Bool
    public let actor: GHEvent.EIndividual
    public let org: GHEvent.EIndividual?
    public let created_at: Date
    public let id: String
    public let payload: EventPayloadType?
    public let repo: ERepository?
    
    fileprivate static let payloadConstructorDict: [GHEvent.EventType: EventPayloadType.Type] =
        [GHEvent.EventType.WatchEvent: WatchEventPayload.self]
}


extension GHEvent: Decodable {
    public static func decode(_ json: JSON) -> Decoded<GHEvent> {
        let creator = curry(GHEvent.init)
        let tmp = creator <^> json <| "type"
            <*> json <| "public"
            <*> json <| "actor"
            <*> json <|? "org"
            <*> json <| "created_at"
            <*> json <| "id"
        
        let _payload: Decoded<EventPayloadType>?
            = ((json <| "type").value as GHEvent.EventType?)
            .flatMap {payloadConstructorDict[$0]?.decode(json)}
        
        let payload: Decoded<EventPayloadType?> = _payload == nil
            ? Decoded<EventPayloadType?>.success(nil)
            : _payload!.map(Optional.some)

        let tmp5 = tmp <*> payload <*> json <|? "repo"
        return tmp5
    }
}

extension GHEvent.EventType: GHAPIModelType {
    public var debugDescription: String {
        return "Event.EIndividual id: \(self.rawValue) "
    }
    
    public static func decode(_ json: JSON) -> Decoded<GHEvent.EventType> {
        switch json {
        case .string(let typeStr):
            guard let et = GHEvent.EventType.init(rawValue: typeStr) else {
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

extension GHEvent.EIndividual: GHAPIModelType {
    public static func == (lhs: GHEvent.EIndividual, rhs: GHEvent.EIndividual) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var debugDescription: String {
        return "Event.EIndividual id: \(self.id) "
    }
    
    public static func decode(_ json: JSON) -> Decoded<GHEvent.EIndividual> {
        let creator = curry(GHEvent.EIndividual.init)
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

extension GHEvent.ERepository: GHAPIModelType {
    public static func == (lhs: GHEvent.ERepository, rhs: GHEvent.ERepository) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var debugDescription: String {
        return "Event.EIndividual id: \(self.id) "
    }
    
    public static func decode(_ json: JSON) -> Decoded<GHEvent.ERepository> {
        let creator = curry(GHEvent.ERepository.init)
        let tmp = creator
            <^> json <| "id"
            <*> json <| "name"
            <*> json <| "url"
        return tmp
    }
    public func encode() -> [String:Any] {
        var result: [String:Any] = [:]
        result["id"] = self.id
        result["name"] = self.name
        result["url"] = self.url.absoluteString
        return result
    }
}







































