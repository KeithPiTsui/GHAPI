//
//  Commit.swift
//  GHAPI
//
//  Created by Pi on 11/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct Commit {
    public struct CCommit {
        public struct Person {
            public let name: String
            public let email: String
            public let date: Date
        }
        public let author: Person
        public let committer: Person
        public let message: String
        public let tree: Branch.BCommit
        public let url: String
        public let comment_count: Int
    }
    
    public struct Parent {
        public let sha: String
        public let url: String
        public let html_url: String
    }
    
    public let sha: String
    public let commit: CCommit
    public let url: String
    public let html_url: String
    public let comments_url: String
    public let author: User
    public let committer: User
    public let parents: [Parent]
}

extension Commit: Equatable {}
public func == (lhs: Commit, rhs: Commit) -> Bool {
    return lhs.sha == rhs.sha
}

extension Commit: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "commit sha: \(self.sha) "
    }
}

extension Commit: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Commit> {
        let creator = curry(Commit.init)
        let tmp = creator
            <^> json <| "sha"
            <*> json <| "commit"
            <*> json <| "url"
            <*> json <| "html_url"
        let tmp1 = tmp
            <*> json <| "comments_url"
            <*> json <| "author"
            <*> json <| "committer"
        
        return tmp1
                <*> json <|| "parents"
    }
}

extension Commit: EncodableType {
    public func encode() -> [String:Any] {
        var result: [String:Any] = [:]
        result["sha"] = self.sha
        result["commit"] = self.commit.encode()
        result["url"] = self.url
        result["html_url"] = self.html_url
        result["comments_url"] = self.comments_url
        result["author"] = self.author.encode()
        result["committer"] = self.committer.encode()
        result["parents"] = self.parents.map{$0.encode()}
        return result
    }
}


extension Commit.CCommit: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Commit.CCommit> {
        let tmp = curry(Commit.CCommit.init)
            <^> json <| "author"
            <*> json <| "committer"
            <*> json <| "message"
            <*> json <| "tree"
            <*> json <| "url"
            <*> json <| "comment_count"
        return tmp
    }
}

extension Commit.CCommit: EncodableType {
    public func encode() -> [String:Any] {
        var result: [String:Any] = [:]
        result["author"] = self.author.encode()
        result["committer"] = self.committer.encode()
        result["message"] = self.message
        result["tree"] = self.tree.encode()
        result["url"] = self.url
        result["comment_count"] = self.comment_count
        return result
    }
}

extension Commit.CCommit.Person: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Commit.CCommit.Person> {
        let tmp = curry(Commit.CCommit.Person.init)
            <^> json <| "name"
            <*> json <| "email"
            <*> json <| "date"
        return tmp
    }
}

extension Commit.CCommit.Person: EncodableType {
    public func encode() -> [String:Any] {
        var result: [String:Any] = [:]
        result["name"] = self.name
        result["email"] = self.email
        result["date"] = self.date.ISO8601DateRepresentation
        return result
    }
}

extension Commit.Parent: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Commit.Parent> {
        let tmp = curry(Commit.Parent.init)
            <^> json <| "sha"
            <*> json <| "url"
            <*> json <| "html_url"
        return tmp
    }
}

extension Commit.Parent: EncodableType {
    public func encode() -> [String:Any] {
        var result: [String:Any] = [:]
        result["sha"] = self.sha
        result["url"] = self.url
        result["html_url"] = self.html_url
        return result
    }
}
