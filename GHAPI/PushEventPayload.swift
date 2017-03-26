//
//  PushEventPayload.swift
//  GHAPI
//
//  Created by Pi on 13/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct PushEventPayload: EventPayloadType {
  public struct PCommit {
    public struct PCPerson {
      public let name: String
      public let email: String
      public let username: String?
    }
    public let id: String?
    public let tree_id: String?
    public let distinct: Bool
    public let message: String
    public let timestamp: Date?
    public let url: URL
    public let author: PushEventPayload.PCommit.PCPerson
    public let committer: PushEventPayload.PCommit.PCPerson?
    public let added: [String]?
    public let removed: [String]?
    public let modified: [String]?
    public let sha: String?
  }

  public let ref: String
  public let before: String
  public let after: String?
  public let created: Bool?
  public let deleted: Bool?
  public let forced: Bool?
  public let base_ref: String?
  public let compare: URL?
  public let commits: [PushEventPayload.PCommit]
  public let head_commit: PushEventPayload.PCommit?
  public let repository: Repository?
  public let pusher: PushEventPayload.PCommit.PCPerson?
  public let sender: UserLite?
  public let push_id: UInt?
  public let size: UInt?
  public let distinct_size: UInt?
  public let head: String?
}

extension PushEventPayload.PCommit.PCPerson: GHAPIModelType {
  public static func == (lhs: PushEventPayload.PCommit.PCPerson, rhs: PushEventPayload.PCommit.PCPerson) -> Bool {
    return lhs.name == rhs.name
  }
  public static func decode(_ json: JSON) -> Decoded<PushEventPayload.PCommit.PCPerson> {
    let creator = curry(PushEventPayload.PCommit.PCPerson.init)
    let tmp = creator
      <^> json <| "name"
      <*> json <| "email"
      <*> json <|? "username"
    return tmp
  }
  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["email"] = self.email
    result["name"] = self.name
    result["username"] = self.username
    return result
  }
}

extension PushEventPayload.PCommit: GHAPIModelType {
  public static func == (lhs: PushEventPayload.PCommit, rhs: PushEventPayload.PCommit) -> Bool {
    return lhs.id == rhs.id
  }

  public static func decode(_ json: JSON) -> Decoded<PushEventPayload.PCommit> {
    let creator = curry(PushEventPayload.PCommit.init)
    let tmp = creator
      <^> json <|? "id"
      <*> json <|? "tree_id"
      <*> json <| "distinct"
    let tmp2 = tmp
      <*> json <| "message"
      <*> json <|? "timestamp"
      <*> json <| "url"
    let tmp3 = tmp2
      <*> json <| "author"
      <*> json <|? "committer"
      <*> json <||? "added"
      <*> json <||? "removed"
      <*> json <||? "modified"
      <*> json <|? "sha"
    return tmp3
  }
  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["id"] = self.id
    result["tree_id"] = self.tree_id
    result["distinct"] = self.distinct
    result["message"] = self.message
    result["timestamp"] = self.timestamp?.ISO8601DateRepresentation
    result["url"] = self.url.absoluteString
    result["author"] = self.author.encode()
    result["committer"] = self.committer?.encode()
    result["added"] = self.added
    result["removed"] = self.removed
    result["modified"] = self.modified
    result["sha"] = self.sha
    return result
  }
}

extension PushEventPayload: GHAPIModelType {
  public static func == (lhs: PushEventPayload, rhs: PushEventPayload) -> Bool {
    return lhs.ref == rhs.ref
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    let creator = curry(PushEventPayload.init)
    let tmp = creator
      <^> json <| "ref"
      <*> json <| "before"
      <*> json <|? "after"
      <*> json <|? "created"
      <*> json <|? "deleted"
    let tmp1 = tmp
      <*> json <|? "forced"
      <*> json <|? "base_ref"
      <*> json <|? "compare"
      <*> json <|| "commits"
      <*> json <|? "head_commit"
    let tmp2 = tmp1
      <*> json <|? "repository"
    let tmp21 = tmp2
      <*> json <|? "pusher"
    let tmp22 = tmp21
      <*> json <|? "sender"
    let tmp3 = tmp22
      <*> json <|? "push_id"
      <*> json <|? "size"
      <*> json <|? "distinct_size"
      <*> json <|? "head"

    if case Decoded.failure(_) = tmp3 {
      print("json with \(json)")
    }

    return tmp3.map{$0 as EventPayloadType}
  }

  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["ref"] = self.ref
    result["before"] = self.before
    result["after"] = self.after
    result["created"] = self.created
    result["deleted"] = self.deleted
    result["forced"] = self.forced
    result["base_ref"] = self.base_ref
    result["compare"] = self.compare?.absoluteString
    result["commits"] = self.commits.map{$0.encode()}
    result["head_commit"] = self.head_commit?.encode()
    result["repository"] = self.repository?.encode()
    result["pusher"] = self.pusher?.encode()
    result["sender"] = self.sender?.encode()
    result["push_id"] = self.push_id
    result["size"] = self.size
    result["distinct_size"] = self.distinct_size
    result["head"] = self.head

    return result
  }
}






/**
  Multiple(MissingKey(login), 
 MissingKey(id), 
 Multiple(MissingKey(avatar_url), 
 MissingKey(gravatar_id)), 
 Multiple(MissingKey(url), 
 MissingKey(html_url), 
 MissingKey(followers_url), 
 MissingKey(following_url), 
 MissingKey(gists_url), 
 MissingKey(starred_url), 
 MissingKey(subscriptions_url), 
 MissingKey(organizations_url), 
 MissingKey(repos_url), 
 MissingKey(events_url), 
 MissingKey(received_events_url)), 
 MissingKey(type), MissingKey(site_admin), 
 Multiple(TypeMismatch(Expected Date, got Number(1430869212)), TypeMismatch(Expected Date, got Number(1430869217))), 
 MissingKey(push_id), 
 MissingKey(size), 
 MissingKey(distinct_size), 
 MissingKey(head))
 
 
 */

















