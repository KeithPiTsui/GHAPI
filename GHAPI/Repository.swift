//
//  Repository.swift
//  GHAPI
//
//  Created by Pi on 06/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct Repository {
    public let id: UInt
    public let name: String
    public let full_name: String
    public let owner: RepositoryOwner
    public let `private`: Bool
    public let html_url: String
    public let description: String?
    public let fork: Bool
    public let url: String
    
    public struct Dates {
        public let created_at: Date
        public let updated_at: Date
        public let pushed_at: Date
    }
    public let dates: Dates
    
    public let homepage: String?
    public let size: UInt
    public let stargazers_count: UInt
    public let watchers_count: UInt
    public let language: String?
    public let forks_count: UInt
    public let open_issues_count: UInt
    public let master_branch: String?
    public let default_branch: String?
    public let score: Double
}

extension Repository: Equatable {
    public static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Repository: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "full name: \(self.full_name) \nid: \(self.id)"
    }
}

extension Repository: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Repository> {
        
        let creator = curry(Repository.init)
        let temp = creator
            <^> json <| "id"
            <*> json <| "name"
            <*> json <| "full_name"
        
        let temp2 = temp
            <*> json <| "owner"
        
        let temp3 = temp2
            <*> json <| "private"
            <*> json <| "html_url"
            <*> json <|? "description"
            <*> json <| "fork"
            <*> json <| "url"
        
        let temp4 = temp3
            <*> Repository.Dates.decode(json)
            <*> json <|? "homepage"
            <*> json <| "size"
            <*> json <| "stargazers_count"
            <*> json <| "watchers_count"
        
        let temp5 = temp4
            <*> json <|? "language"
            <*> json <| "forks_count"
            <*> json <| "open_issues_count"
            <*> json <|? "master_branch"
            <*> json <|? "default_branch"
            <*> json <| "score"
        
        
        return temp5
    }
}

extension Repository: EncodableType {
    public func encode() -> [String:Any] {
        let result: [String:Any] = [:]
        return result
    }
}

extension Repository.Dates: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Repository.Dates> {
        return curry(Repository.Dates.init)
            <^> json <| "created_at"
            <*> json <| "updated_at"
            <*> json <| "pushed_at"
    }
}

extension Repository.Dates: EncodableType {
    public func encode() -> [String:Any] {
        return [ "created_at": self.created_at, "updated_at": self.updated_at, "pushed_at": self.pushed_at]
    }
}

