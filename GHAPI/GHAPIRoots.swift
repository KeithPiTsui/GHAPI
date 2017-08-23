//
//  GHAPIRoots.swift
//  GHAPI
//
//  Created by Pi on 22/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct GHAPIRoots {
  public struct GURLs {
    public let current_user_url: URL
    public let current_user_authorizations_html_url: URL
    public let authorizations_url: URL
    public let emails_url: URL
    public let followers_url: URL
    public let following_url: URL
    public let keys_url: URL
    public let notifications_url: URL
    public let current_user_repositories_url: URL
    public let starred_url: URL
    public let starred_gists_url: URL
    public let user_organizations_url: URL
  }
  public struct GURLs2 {
    public let code_search_url: URL
    public let commit_search_url: URL
    public let emojis_url: URL
    public let events_url: URL
    public let feeds_url: URL
    public let gists_url: URL
    public let hub_url: URL
    public let issue_search_url: URL
    public let issues_url: URL
    public let organization_repositories_url: URL
    public let organization_url: URL
    public let public_gists_url: URL
    public let rate_limit_url: URL
    public let repository_url: URL
    public let repository_search_url: URL
    public let team_url: URL
    public let user_url: URL
    public let user_repositories_url: URL
    public let user_search_url: URL
  }
  public let urls: GURLs
  public let urls2: GURLs2
}

extension GHAPIRoots: GHAPIModelType {
  public static func == (lhs: GHAPIRoots, rhs: GHAPIRoots) -> Bool {
    return lhs.urls == rhs.urls
      && lhs.urls2 == rhs.urls2
  }
  public static func decode(_ json: JSON) -> Decoded<GHAPIRoots> {
    return curry(GHAPIRoots.init)
      <^> GHAPIRoots.GURLs.decode(json)
      <*> GHAPIRoots.GURLs2.decode(json)
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result = result.withAllValuesFrom(self.urls.encode())
    result = result.withAllValuesFrom(self.urls2.encode())
    return result
  }
}

extension GHAPIRoots.GURLs: GHAPIModelType {
  public static func == (lhs: GHAPIRoots.GURLs, rhs: GHAPIRoots.GURLs) -> Bool {
    return lhs.current_user_url == rhs.current_user_url
  }
  public static func decode(_ json: JSON) -> Decoded<GHAPIRoots.GURLs> {
    let creator = curry(GHAPIRoots.GURLs.init)
      <^> json <| "current_user_url"
    let tmp = creator
      <*> json <| "current_user_authorizations_html_url"
      <*> json <| "authorizations_url"
      <*> json <| "emails_url"
      <*> json <| "followers_url"
    let tmp2 = tmp
      <*> json <| "following_url"
      <*> json <| "keys_url"
      <*> json <| "notifications_url"
      <*> json <| "current_user_repositories_url"
      <*> json <| "starred_url"
    let tmp3 = tmp2
      <*> json <| "starred_gists_url"
      <*> json <| "user_organizations_url"
    return tmp3
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["current_user_url"] = self.current_user_url.absoluteString
    result["current_user_authorizations_html_url"] = self.current_user_authorizations_html_url.absoluteString
    result["authorizations_url"] = self.authorizations_url.absoluteString
    result["emails_url"] = self.emails_url.absoluteString
    result["followers_url"] = self.followers_url.absoluteString
    result["following_url"] = self.followers_url.absoluteString
    result["keys_url"] = self.keys_url.absoluteString
    result["notifications_url"] = self.notifications_url.absoluteString
    result["current_user_repositories_url"] = self.current_user_repositories_url.absoluteString
    result["starred_url"] = self.starred_url.absoluteString
    result["starred_gists_url"] = self.starred_gists_url.absoluteString
    result["user_organizations_url"] = self.user_organizations_url.absoluteString
    return result
  }
}

extension GHAPIRoots.GURLs2: GHAPIModelType {
  public static func == (lhs: GHAPIRoots.GURLs2, rhs: GHAPIRoots.GURLs2) -> Bool {
    return lhs.code_search_url == rhs.code_search_url
  }
  public static func decode(_ json: JSON) -> Decoded<GHAPIRoots.GURLs2> {
    let creator = curry(GHAPIRoots.GURLs2.init)
      <^> json <| "code_search_url"
    let tmp = creator
      <*> json <| "commit_search_url"
      <*> json <| "emojis_url"
      <*> json <| "events_url"
      <*> json <| "feeds_url"
    let tmp2 = tmp
      <*> json <| "gists_url"
      <*> json <| "hub_url"
      <*> json <| "issue_search_url"
      <*> json <| "issues_url"
      <*> json <| "organization_repositories_url"
    let tmp3 = tmp2
      <*> json <| "organization_url"
      <*> json <| "public_gists_url"
      <*> json <| "rate_limit_url"
      <*> json <| "repository_url"
      <*> json <| "repository_search_url"
    let tmp4 = tmp3
      <*> json <| "team_url"
      <*> json <| "user_url"
      <*> json <| "user_repositories_url"
      <*> json <| "user_search_url"

    return tmp4
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["code_search_url"] = self.code_search_url.absoluteString
    result["commit_search_url"] = self.commit_search_url.absoluteString
    result["emojis_url"] = self.emojis_url.absoluteString
    result["events_url"] = self.events_url.absoluteString
    result["feeds_url"] = self.feeds_url.absoluteString
    result["gists_url"] = self.gists_url.absoluteString
    result["hub_url"] = self.hub_url.absoluteString
    result["issue_search_url"] = self.issue_search_url.absoluteString
    result["issues_url"] = self.issues_url.absoluteString
    result["organization_repositories_url"] = self.organization_repositories_url.absoluteString
    result["organization_url"] = self.organization_url.absoluteString
    result["public_gists_url"] = self.public_gists_url.absoluteString
    result["rate_limit_url"] = self.rate_limit_url.absoluteString
    result["repository_url"] = self.repository_url.absoluteString
    result["repository_search_url"] = self.repository_search_url.absoluteString
    result["team_url"] = self.team_url.absoluteString
    result["user_url"] = self.user_url.absoluteString
    result["user_repositories_url"] = self.user_repositories_url.absoluteString
    result["user_search_url"] = self.user_search_url.absoluteString
    return result
  }
}

















