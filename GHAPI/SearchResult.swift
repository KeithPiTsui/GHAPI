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

//public struct SearchResult {
//    public let total_count: Int
//    public let incomplete_results: Bool
//    public let items: [Repository]
//}
//
//extension SearchResult: Equatable {
//    public static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
//        return lhs.total_count == rhs.total_count
//            && lhs.incomplete_results == rhs.incomplete_results
//    }
//}
//
//extension SearchResult: CustomDebugStringConvertible {
//    public var debugDescription: String {
//        return "total_count: \(self.total_count) \nincomplete_results: \(self.incomplete_results)"
//    }
//}
//
//extension SearchResult: Decodable {
//    public static func decode(_ json: JSON) -> Decoded<SearchResult> {
//        return curry(SearchResult.init)
//            <^> json <| "total_count"
//            <*> json <| "incomplete_results"
//            <*> json <|| "items"
//    }
//}
//
//extension SearchResult: EncodableType {
//    public func encode() -> [String:Any] {
//        var result: [String:Any] = [:]
//        result["total_count"] = self.total_count
//        result["incomplete_results"] = self.incomplete_results
//        return result
//    }
//}

