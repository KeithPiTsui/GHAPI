//
//  Commit.swift
//  GHAPI
//
//  Created by Pi on 11/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


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
    public let tree: BranchLite.BCommit
    public let url: URL
    public let comment_count: Int
  }

  public struct Parent {
    public let sha: String
    public let url: URL
    public let html_url: URL
  }

  public struct CStats {
    public let total: UInt
    public let additions: UInt
    public let deletions: UInt
  }

  public struct CFile {
    public let sha: String
    public let filename: String
    public let status: String
    public let additions: UInt
    public let deletions: UInt
    public let changes: UInt
    public let blob_url: URL?
    public let raw_url: URL?
    public let contents_url: URL
    public let patch: String?
  }

  public let sha: String
  public let commit: CCommit
  public let url: URL
  public let html_url: URL
  public let comments_url: URL
  public let author: User?
  public let committer: User?
  public let parents: [Parent]
  public let stats: Commit.CStats?
  public let files: [Commit.CFile]?
}

extension Commit: GHAPIModelType {
  public static func == (lhs: Commit, rhs: Commit) -> Bool {
    return lhs.sha == rhs.sha
  }

  public static func decode(_ json: JSON) -> Decoded<Commit> {
    let creator = curry(Commit.init)
    let tmp = creator
      <^> json <| "sha"
      <*> json <| "commit"
      <*> json <| "url"
      <*> json <| "html_url"
    let tmp1 = tmp
      <*> json <| "comments_url"
      <*> json <|? "author"
      <*> json <|? "committer"

    return tmp1
      <*> json <|| "parents"
      <*> json <|? "stats"
      <*> json <||? "files"
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["sha"] = self.sha
    result["commit"] = self.commit.encode()
    result["url"] = self.url.absoluteString
    result["html_url"] = self.html_url.absoluteString
    result["comments_url"] = self.comments_url.absoluteString
    result["author"] = self.author?.encode()
    result["committer"] = self.committer?.encode()
    result["parents"] = self.parents.map{$0.encode()}
    result["stats"] = self.stats?.encode()
    result["files"] = self.files?.map{$0.encode()}
    return result
  }
}

extension Commit.CCommit: GHAPIModelType {
  public static func == (lhs: Commit.CCommit, rhs: Commit.CCommit) -> Bool {
    return lhs.url == rhs.url
  }

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

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["author"] = self.author.encode()
    result["committer"] = self.committer.encode()
    result["message"] = self.message
    result["tree"] = self.tree.encode()
    result["url"] = self.url.absoluteString
    result["comment_count"] = self.comment_count
    return result
  }
}


extension Commit.CCommit.Person: GHAPIModelType {
  public static func == (lhs: Commit.CCommit.Person, rhs: Commit.CCommit.Person) -> Bool {
    return lhs.email == rhs.email
  }
  public static func decode(_ json: JSON) -> Decoded<Commit.CCommit.Person> {
    let tmp = curry(Commit.CCommit.Person.init)
      <^> json <| "name"
      <*> json <| "email"
      <*> json <| "date"
    return tmp
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["name"] = self.name
    result["email"] = self.email
    result["date"] = self.date.ISO8601DateRepresentation
    return result
  }
}

extension Commit.Parent: GHAPIModelType {
  public static func == (lhs: Commit.Parent, rhs: Commit.Parent) -> Bool {
    return lhs.sha == rhs.sha
  }
  public static func decode(_ json: JSON) -> Decoded<Commit.Parent> {
    let tmp = curry(Commit.Parent.init)
      <^> json <| "sha"
      <*> json <| "url"
      <*> json <| "html_url"
    return tmp
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["sha"] = self.sha
    result["url"] = self.url.absoluteString
    result["html_url"] = self.html_url.absoluteString
    return result
  }
}

extension Commit.CStats: GHAPIModelType {
  public static func == (lhs: Commit.CStats, rhs: Commit.CStats) -> Bool {
    return lhs.total == rhs.total
      && lhs.additions == rhs.additions
      && lhs.deletions == rhs.deletions
  }
  public static func decode(_ json: JSON) -> Decoded<Commit.CStats> {
    let tmp = curry(Commit.CStats.init)
      <^> json <| "total"
      <*> json <| "additions"
      <*> json <| "deletions"
    return tmp
  }
  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["total"] = self.total
    result["additions"] = self.additions
    result["deletions"] = self.deletions
    return result
  }
}
extension Commit.CFile: GHAPIModelType {
  public static func == (lhs: Commit.CFile, rhs: Commit.CFile) -> Bool {
    return lhs.sha == rhs.sha
  }
  public static func decode(_ json: JSON) -> Decoded<Commit.CFile> {
    let creator = curry(Commit.CFile.init)
    let tmp = creator
      <^> json <| "sha"
      <*> json <| "filename"
      <*> json <| "status"
      <*> json <| "additions"
      <*> json <| "deletions"
    let tmp2 = tmp
      <*> json <| "changes"
      <*> json <|? "blob_url"
      <*> json <|? "raw_url"
      <*> json <| "contents_url"
      <*> json <|? "patch"
    return tmp2
  }
  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["sha"] = self.sha
    result["filename"] = self.filename
    result["status"] = self.status
    result["additions"] = self.additions
    result["deletions"] = self.deletions
    result["changes"] = self.changes
    result["blob_url"] = self.blob_url?.absoluteString
    result["raw_url"] = self.raw_url?.absoluteString
    result["contents_url"] = self.contents_url.absoluteString
    result["patch"] = self.patch
    return result
  }
}
