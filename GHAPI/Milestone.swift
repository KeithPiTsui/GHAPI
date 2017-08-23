//
//  Milestone.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct Milestone {
  public let url: URL
  public let html_url: URL
  public let labels_url: URL
  public let id: UInt
  public let number: UInt
  public let title: String
  public let desc: String?
  public let creator: UserLite
  public let open_issues: UInt
  public let closed_issues: UInt
  public let state: String
  public let created_at: Date
  public let updated_at: Date
  public let due_on: Date?
  public let closed_at: Date?
}

/**
 {
 "url": "https://api.github.com/repos/Alamofire/Alamofire/milestones/13",
 "html_url": "https://github.com/Alamofire/Alamofire/milestone/13",
 "labels_url": "https://api.github.com/repos/Alamofire/Alamofire/milestones/13/labels",
 "id": 1315501,
 "number": 13,
 "title": "2.0.2",
 "description": "Bug fixes",
 "creator": {
 "login": "cnoon",
 "id": 169110,
 "avatar_url": "https://avatars2.githubusercontent.com/u/169110?v=3",
 "gravatar_id": "",
 "url": "https://api.github.com/users/cnoon",
 "html_url": "https://github.com/cnoon",
 "followers_url": "https://api.github.com/users/cnoon/followers",
 "following_url": "https://api.github.com/users/cnoon/following{/other_user}",
 "gists_url": "https://api.github.com/users/cnoon/gists{/gist_id}",
 "starred_url": "https://api.github.com/users/cnoon/starred{/owner}{/repo}",
 "subscriptions_url": "https://api.github.com/users/cnoon/subscriptions",
 "organizations_url": "https://api.github.com/users/cnoon/orgs",
 "repos_url": "https://api.github.com/users/cnoon/repos",
 "events_url": "https://api.github.com/users/cnoon/events{/privacy}",
 "received_events_url": "https://api.github.com/users/cnoon/received_events",
 "type": "User",
 "site_admin": false
 },
 "open_issues": 0,
 "closed_issues": 3,
 "state": "closed",
 "created_at": "2015-09-20T23:20:38Z",
 "updated_at": "2015-09-22T03:27:51Z",
 "due_on": "2015-09-20T07:00:00Z",
 "closed_at": "2015-09-22T03:27:51Z"
 }
 */

extension Milestone: GHAPIModelType {
  public static func == (lhs: Milestone, rhs: Milestone) -> Bool {
    return lhs.id == rhs.id
  }
  public static func decode(_ json: JSON) -> Decoded<Milestone> {
    let creator = curry(Milestone.init)
    let tmp = creator
      <^> json <| "url"
      <*> json <| "html_url"
      <*> json <| "labels_url"
      <*> json <| "id"
      <*> json <| "number"
    let tmp2 = tmp
      <*> json <| "title"
      <*> json <|? "desc"
      <*> json <| "creator"
      <*> json <| "open_issues"
      <*> json <| "closed_issues"
    let tmp3 = tmp2
      <*> json <| "state"
      <*> json <| "created_at"
      <*> json <| "updated_at"
      <*> json <|? "due_on"
      <*> json <|? "closed_at"
    return tmp3
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["html_url"] = self.html_url.absoluteString
    result["labels_url"] = self.labels_url.absoluteString
    result["id"] = self.id
    result["number"] = self.number
    result["title"] = self.title
    result["desc"] = self.desc
    result["creator"] = self.creator.encode()
    result["open_issues"] = self.open_issues
    result["closed_issues"] = self.closed_issues
    result["state"] = self.state
    result["created_at"] = self.created_at.ISO8601DateRepresentation
    result["updated_at"] = self.updated_at.ISO8601DateRepresentation
    result["due_on"] = self.due_on?.ISO8601DateRepresentation
    result["closed_at"] = self.closed_at?.ISO8601DateRepresentation
    return result
  }
}
