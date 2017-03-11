//
//  Branch.swift
//  GHAPI
//
//  Created by Pi on 11/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes


public struct Branch {
    public struct BCommit {
        public let sha: String
        public let url: URL
    }
    public let name: String
    public let commit: BCommit
    
}

extension Branch: Equatable {}
public func == (lhs: Branch, rhs: Branch) -> Bool {
    return lhs.name == rhs.name && lhs.commit.sha == rhs.commit.sha
}

extension Branch: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "name: \(self.name) "
    }
}

extension Branch: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Branch> {
        return
            curry(Branch.init)
                <^> json <| "name"
                <*> json <| "commit"
    }
}

extension Branch: EncodableType {
    public func encode() -> [String:Any] {
        var result: [String:Any] = [:]
        result["name"] = self.name
        result["commit"] = self.commit.encode()
        return result
    }
}

extension Branch.BCommit: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Branch.BCommit> {
        let tmp = curry(Branch.BCommit.init)
            <^> json <| "sha"
            <*> json <| "url"
        return tmp
    }
}

extension Branch.BCommit: EncodableType {
    public func encode() -> [String:Any] {
        var result: [String:Any] = [:]
        result["sha"] = self.sha
        result["url"] = self.url.absoluteString
        return result
    }
}



