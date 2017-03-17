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
  public struct URLs {
    public let url: URL
    public let htmlUrl: URL
    public let branches_url: URL
    public let commits_url: URL
  }

  public let id: UInt
  public let name: String
  public let full_name: String
  public let owner: UserLite
  public let `private`: Bool
  public let description: String?
  public let fork: Bool
  public let urls: Repository.URLs

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
  public let score: Double?
}

extension Repository: GHAPIModelType {
  public static func == (lhs: Repository, rhs: Repository) -> Bool {
    return lhs.id == rhs.id
  }

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
      <*> json <|? "description"
      <*> json <| "fork"
      <*> Repository.URLs.decode(json)

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
      <*> json <|? "score"
    return temp5
  }

  public func encode() -> [String:Any] {
    let result: [String:Any] = [:]
    return result
  }
}

extension Repository.Dates: GHAPIModelType {
  public static func == (lhs: Repository.Dates, rhs: Repository.Dates) -> Bool {
    return lhs.created_at == rhs.created_at
      && lhs.updated_at == rhs.updated_at
      && lhs.pushed_at == rhs.pushed_at
  }

  public static func decode(_ json: JSON) -> Decoded<Repository.Dates> {
    return curry(Repository.Dates.init)
      <^> json <| "created_at"
      <*> json <| "updated_at"
      <*> json <| "pushed_at"
  }

  public func encode() -> [String:Any] {
    return [ "created_at": self.created_at.ISO8601DateRepresentation,
             "updated_at": self.updated_at.ISO8601DateRepresentation,
             "pushed_at": self.pushed_at.ISO8601DateRepresentation]
  }
}

extension Repository.URLs: GHAPIModelType {
  public static func == (lhs: Repository.URLs, rhs: Repository.URLs) -> Bool {
    return lhs.url == rhs.url
  }

  public static func decode(_ json: JSON) -> Decoded<Repository.URLs> {
    let tmp = curry(Repository.URLs.init)
      <^> json <| "url"
      <*> json <| "html_url"
      <*> json <| "branches_url"
      <*> json <| "commits_url"
    return tmp
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["html_url"] = self.htmlUrl.absoluteString
    result["commits_url"] = self.commits_url.absoluteString
    result["branches_url"] = self.branches_url.absoluteString
    return result
  }
}

