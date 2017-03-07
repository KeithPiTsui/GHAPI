//
//  RepositorySearchResult.swift
//  GHAPI
//
//  Created by Pi on 07/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes


public struct RepositorySearchResult {
    public let total_count: Int
    public let incomplete_results: Bool
    public let items: [Repository]
}

extension RepositorySearchResult: Equatable {
    public static func == (lhs: RepositorySearchResult, rhs: RepositorySearchResult) -> Bool {
        return lhs.total_count == rhs.total_count
            && lhs.incomplete_results == rhs.incomplete_results
    }
}

extension RepositorySearchResult: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "total_count: \(self.total_count) \nincomplete_results: \(self.incomplete_results)"
    }
}

extension RepositorySearchResult: Decodable {
    public static func decode(_ json: JSON) -> Decoded<RepositorySearchResult> {
        return curry(RepositorySearchResult.init)
            <^> json <| "total_count"
            <*> json <| "incomplete_results"
            <*> json <|| "items"
    }
}

extension RepositorySearchResult: EncodableType {
    public func encode() -> [String:Any] {
        var result: [String:Any] = [:]
        result["total_count"] = self.total_count
        result["incomplete_results"] = self.incomplete_results
        return result
    }
}
