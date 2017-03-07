//
//  UserSearchResult.swift
//  GHAPI
//
//  Created by Pi on 07/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes


public struct UserSearchResult {
    public let total_count: Int
    public let incomplete_results: Bool
    public let items: [User]
}

extension UserSearchResult: Equatable {
    public static func == (lhs: UserSearchResult, rhs: UserSearchResult) -> Bool {
        return lhs.total_count == rhs.total_count
            && lhs.incomplete_results == rhs.incomplete_results
    }
}

extension UserSearchResult: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "total_count: \(self.total_count) \nincomplete_results: \(self.incomplete_results)"
    }
}

extension UserSearchResult: Decodable {
    public static func decode(_ json: JSON) -> Decoded<UserSearchResult> {
        return curry(UserSearchResult.init)
            <^> json <| "total_count"
            <*> json <| "incomplete_results"
            <*> json <|| "items"
    }
}

extension UserSearchResult: EncodableType {
    public func encode() -> [String:Any] {
        var result: [String:Any] = [:]
        result["total_count"] = self.total_count
        result["incomplete_results"] = self.incomplete_results
        return result
    }
}
