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
    let name: String
}

extension SearchResult: Equatable {}
public func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return true
}

extension SearchResult: CustomDebugStringConvertible {
    public var debugDescription: String {
        return ""
    }
}

extension SearchResult: Decodable {
    public static func decode(_ json: JSON) -> Decoded<SearchResult> {
        
        let create = curry(SearchResult.init)
        let tmp = create
            <^> json <| "login"
        return tmp
        
    }
}

extension SearchResult: EncodableType {
    public func encode() -> [String:Any] {
        let result: [String:Any] = [:]
        return result
    }
}

