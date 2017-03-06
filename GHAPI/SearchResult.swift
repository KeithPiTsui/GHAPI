//
//  SearchResult.swift
//  GHAPI
//
//  Created by Pi on 06/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct SearchResult {
    let total_count: Int
    let incomplete_results: Bool
}

extension SearchResult: Equatable {}
public func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.total_count == rhs.total_count
        && lhs.incomplete_results == rhs.incomplete_results
}

extension SearchResult: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "total_count: \(self.total_count) \nincomplete_results: \(self.incomplete_results)"
    }
}

extension SearchResult: Decodable {
    public static func decode(_ json: JSON) -> Decoded<SearchResult> {
        
        let create = curry(SearchResult.init)
        let tmp = create
            <^> json <| "total_count"
            <*> json <| "incomplete_results"
        return tmp
        
    }
}

extension SearchResult: EncodableType {
    public func encode() -> [String:Any] {
        var result: [String:Any] = [:]
        result["total_count"] = self.total_count
        result["incomplete_results"] = self.incomplete_results
        return result
    }
}

