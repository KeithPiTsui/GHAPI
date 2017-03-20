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
  public struct RURLs {
    public let url: URL
    public let htmlUrl: URL
    public let branches_url: URL
    public let commits_url: URL
    public let archive_url: URL
    public let assignees_url: URL
    public let blobs_url: URL
    public let clone_url: URL
    public let collaborators_url: URL
    public let comments_url: URL
    public let compare_url: URL
    public let contents_url: URL
    public let contributors_url: URL
    public let deployments_url: URL
    public let downloads_url: URL
    public let events_url: URL
    public let forks_url: URL
    public let git_commits_url: URL
  }

  public struct RURLs2 {
    public let git_refs_url: URL
    public let git_tags_url: URL
    public let git_url: URL
    public let hooks_url: URL
    public let issue_comment_url: URL
    public let issue_events_url: URL
    public let issues_url: URL
    public let keys_url: URL
    public let labels_url: URL
    public let languages_url: URL
    public let merges_url: URL
    public let milestones_url: URL
    public let mirror_url: URL
  }

  public struct RURLs3 {
    public let notifications_url: URL
    public let pulls_url: URL
    public let releases_url: URL
    public let ssh_url: URL
    public let stargazers_url: URL
    public let statuses_url: URL
    public let subscribers_url: URL
    public let subscription_url: URL
    public let svn_url: URL
    public let tags_url: URL
    public let teams_url: URL
    public let trees_url: URL
  }

  public struct RPermission {
    public let admin: Bool
    public let push: Bool
    public let pull: Bool
  }

  public struct ROthers {
    public let has_issues: Bool
    public let has_wiki: Bool
    public let has_pages: Bool
    public let has_downloads: Bool
    public let permissions: Repository.RPermission
    public let language: String?
    public let forks_count: UInt
    public let open_issues_count: UInt
    public let master_branch: String?
    public let default_branch: String?
    public let score: Double?
  }

  public let id: UInt
  public let name: String
  public let full_name: String
  public let owner: UserLite
  public let `private`: Bool
  public let desc: String?
  public let fork: Bool

  public let urls: Repository.RURLs
  public let urls2: Repository.RURLs2
  public let urls3: Repository.RURLs3

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
  public let others: Repository.ROthers
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
      <*> Repository.RURLs.decode(json)
      <*> Repository.RURLs2.decode(json)
      <*> Repository.RURLs3.decode(json)

    let temp4 = temp3
      <*> Repository.Dates.decode(json)
      <*> json <|? "homepage"
      <*> json <| "size"
      <*> json <| "stargazers_count"
      <*> json <| "watchers_count"

    let temp5 = temp4
      <*> Repository.ROthers.decode(json)
    return temp5
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result = result.withAllValuesFrom(self.urls.encode())
    result = result.withAllValuesFrom(self.urls2.encode())
    result = result.withAllValuesFrom(self.urls3.encode())
    result = result.withAllValuesFrom(self.dates.encode())
    result = result.withAllValuesFrom(self.others.encode())
    result["id"] = self.id
    result["name"] = self.name
    result["full_name"] = self.full_name
    result["owner"] = self.owner.encode()
    result["private"] = self.`private`
    result["description"] = self.desc
    result["fork"] = self.fork
    result["homepage"] = self.homepage
    result["size"] = self.size
    result["stargazers_count"] = self.stargazers_count
    result["watchers_count"] = self.watchers_count
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

extension Repository.RURLs: GHAPIModelType {
  public static func == (lhs: Repository.RURLs, rhs: Repository.RURLs) -> Bool {
    return lhs.url == rhs.url
  }

  public static func decode(_ json: JSON) -> Decoded<Repository.RURLs> {
    let tmp = curry(Repository.RURLs.init)
      <^> json <| "url"
      <*> json <| "html_url"
      <*> json <| "branches_url"
      <*> json <| "commits_url"
    let tmp2 = tmp
      <*> json <| "archive_url"
      <*> json <| "assignees_url"
      <*> json <| "blobs_url"
      <*> json <| "clone_url"
      <*> json <| "collaborators_url"
    let tmp3 = tmp2
      <*> json <| "comments_url"
      <*> json <| "compare_url"
      <*> json <| "contents_url"
      <*> json <| "contributors_url"
      <*> json <| "deployments_url"
      <*> json <| "downloads_url"
      <*> json <| "events_url"
    let tmp4 = tmp3
      <*> json <| "forks_url"
      <*> json <| "git_commits_url"
    return tmp4
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["html_url"] = self.htmlUrl.absoluteString
    result["commits_url"] = self.commits_url.absoluteString
    result["branches_url"] = self.branches_url.absoluteString
    result["archive_url"] = self.archive_url.absoluteString
    result["assignees_url"] = self.assignees_url.absoluteString
    result["blobs_url"] = self.blobs_url.absoluteString
    result["clone_url"] = self.clone_url.absoluteString
    result["collaborators_url"] = self.collaborators_url.absoluteString
    result["comments_url"] = self.comments_url.absoluteString
    result["compare_url"] = self.compare_url.absoluteString
    result["contents_url"] = self.contents_url.absoluteString
    result["contributors_url"] = self.contributors_url.absoluteString
    result["deployments_url"] = self.deployments_url.absoluteString
    result["downloads_url"] = self.downloads_url.absoluteString
    result["events_url"] = self.events_url.absoluteString
    result["forks_url"] = self.forks_url.absoluteString
    result["git_commits_url"] = self.git_commits_url.absoluteString
    return result
  }
}

extension Repository.RURLs2: GHAPIModelType {
  public static func == (lhs: Repository.RURLs2, rhs: Repository.RURLs2) -> Bool {
    return lhs.git_refs_url == rhs.git_refs_url
  }

  public static func decode(_ json: JSON) -> Decoded<Repository.RURLs2> {
    let tmp = curry(Repository.RURLs2.init)
      <^> json <| "git_refs_url"
      <*> json <| "git_tags_url"
      <*> json <| "git_url"
      <*> json <| "hooks_url"
    let tmp2 = tmp
      <*> json <| "issue_comment_url"
      <*> json <| "issue_events_url"
      <*> json <| "issues_url"
      <*> json <| "keys_url"
      <*> json <| "labels_url"
    let tmp3 = tmp2
      <*> json <| "languages_url"
      <*> json <| "merges_url"
      <*> json <| "milestones_url"
      <*> json <| "mirror_url"
    return tmp3
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["git_refs_url"] = self.git_refs_url.absoluteString
    result["git_tags_url"] = self.git_tags_url.absoluteString
    result["git_url"] = self.git_url.absoluteString
    result["hooks_url"] = self.hooks_url.absoluteString
    result["issue_comment_url"] = self.issue_comment_url.absoluteString
    result["issue_events_url"] = self.issue_events_url.absoluteString
    result["issues_url"] = self.issues_url.absoluteString
    result["keys_url"] = self.keys_url.absoluteString
    result["labels_url"] = self.labels_url.absoluteString
    result["languages_url"] = self.languages_url.absoluteString
    result["merges_url"] = self.merges_url.absoluteString
    result["milestones_url"] = self.milestones_url.absoluteString
    result["mirror_url"] = self.mirror_url.absoluteString
    return result
  }
}

extension Repository.RURLs3: GHAPIModelType {
  public static func == (lhs: Repository.RURLs3, rhs: Repository.RURLs3) -> Bool {
    return lhs.ssh_url == rhs.ssh_url
  }

  public static func decode(_ json: JSON) -> Decoded<Repository.RURLs3> {
    let tmp = curry(Repository.RURLs3.init)
      <^> json <| "notifications_url"
      <*> json <| "pulls_url"
      <*> json <| "releases_url"
      <*> json <| "ssh_url"
    let tmp2 = tmp
      <*> json <| "stargazers_url"
      <*> json <| "statuses_url"
      <*> json <| "subscribers_url"
      <*> json <| "subscription_url"
      <*> json <| "svn_url"
    let tmp3 = tmp2
      <*> json <| "tags_url"
      <*> json <| "teams_url"
      <*> json <| "trees_url"
    return tmp3
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["notifications_url"] = self.notifications_url.absoluteString
    result["pulls_url"] = self.pulls_url.absoluteString
    result["releases_url"] = self.releases_url.absoluteString
    result["ssh_url"] = self.ssh_url.absoluteString
    result["stargazers_url"] = self.stargazers_url.absoluteString
    result["statuses_url"] = self.statuses_url.absoluteString
    result["subscribers_url"] = self.subscribers_url.absoluteString
    result["subscription_url"] = self.subscription_url.absoluteString
    result["svn_url"] = self.svn_url.absoluteString
    result["tags_url"] = self.tags_url.absoluteString
    result["teams_url"] = self.teams_url.absoluteString
    result["trees_url"] = self.trees_url.absoluteString
    return result
  }
}

extension Repository.ROthers: GHAPIModelType {
  public static func == (lhs: Repository.ROthers, rhs: Repository.ROthers) -> Bool {
    return lhs.has_issues == rhs.has_issues
  }

  public static func decode(_ json: JSON) -> Decoded<Repository.ROthers> {
    let tmp = curry(Repository.ROthers.init)
      <^> json <| "has_issues"
      <*> json <| "has_wiki"
      <*> json <| "has_pages"
    let tmp2 = tmp
    <*> json <| "has_downloads"
    <*> json <| "permissions"
    <*> json <|? "language"
    <*> json <| "forks_count"
    <*> json <| "open_issues_count"
    let tmp3 = tmp2
    <*> json <|? "master_branch"
    <*> json <|? "default_branch"
    <*> json <|? "score"
    return tmp3
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["has_issues"] = self.has_issues
    result["has_wiki"] = self.has_wiki
    result["has_pages"] = self.has_pages
    result["has_downloads"] = self.has_downloads
    result["permissions"] = self.permissions.encode()
    result["language"] = self.language
    result["forks_count"] = self.forks_count
    result["open_issues_count"] = self.open_issues_count
    result["master_branch"] = self.master_branch
    result["default_branch"] = self.default_branch
    result["score"] = self.score
    return result
  }
}

extension Repository.RPermission: GHAPIModelType {
  public static func == (lhs: Repository.RPermission, rhs: Repository.RPermission) -> Bool {
    return lhs.admin == rhs.admin
      && lhs.push == rhs.push
      && lhs.pull == rhs.pull
  }

  public static func decode(_ json: JSON) -> Decoded<Repository.RPermission> {
    let tmp = curry(Repository.RPermission.init)
      <^> json <| "admin"
      <*> json <| "push"
      <*> json <| "pull"
    return tmp
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["admin"] = self.admin
    result["push"] = self.push
    result["pull"] = self.pull
    return result
  }
}









