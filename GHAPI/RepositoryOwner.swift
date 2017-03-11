//
//  RepositoryOwner.swift
//  GHAPI
//
//  Created by Pi on 06/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct RepositoryOwner {
    public let login: String
    public let id: UInt
    public let avatar_url: URL
    public let gravatar_id: String
    public let url: URL
    public let received_events_url: URL
    public let type: String
}

extension RepositoryOwner: Equatable {}
public func == (lhs: RepositoryOwner, rhs: RepositoryOwner) -> Bool {
    return lhs.id == rhs.id
}

extension RepositoryOwner: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "login: \(self.login) \nid: \(self.id)"
    }
}

extension RepositoryOwner: Decodable {
    public static func decode(_ json: JSON) -> Decoded<RepositoryOwner> {
        return
            curry(RepositoryOwner.init)
            <^> json <| "login"
            <*> json <| "id"
            <*> json <| "avatar_url"
            <*> json <| "gravatar_id"
            <*> json <| "url"
            <*> json <| "received_events_url"
            <*> json <| "type"
        
    }
}

extension RepositoryOwner: EncodableType {
    public func encode() -> [String:Any] {
        var result: [String:Any] = [:]
        result["login"] = self.login
        result["avatar_url"] = self.avatar_url.absoluteString
        result["gravatar_id"] = self.gravatar_id
        result["url"] = self.url.absoluteString
        result["received_events_url"] = self.received_events_url.absoluteString
        result["type"] = self.type
        return result
    }
}



















