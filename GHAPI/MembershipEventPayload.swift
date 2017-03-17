//
//  MembershipEventPayload.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct MembershipEventPayload: EventPayloadType{
  public struct MTeam {
    public let name: String
    public let id: UInt
    public let slug: String
    public let permission: String
    public let url: URL
    public let members_url: URL
    public let repositories_url: URL
  }

  public let action: String
  public let scope: String
  public let member: UserLite
  public let sender: UserLite
  public let team: MembershipEventPayload.MTeam
  public let organization: Organization
}

extension MembershipEventPayload: GHAPIModelType {
  public static func == (lhs: MembershipEventPayload, rhs: MembershipEventPayload) -> Bool {
    return lhs.action == rhs.action
      && lhs.scope == rhs.scope
      && lhs.member == rhs.member
      && lhs.sender == rhs.sender
      && lhs.team == rhs.team
      && lhs.organization == rhs.organization
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(MembershipEventPayload.init)
      <^> json <| "action"
      <*> json <| "scope"
      <*> json <| "member"
      <*> json <| "sender"
      <*> json <| "team"
      <*> json <| "organization"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["scope"] = self.scope
    result["member"] = self.member
    result["sender"] = self.sender
    result["team"] = self.team
    result["organization"] = self.organization
    return result
  }
}

extension MembershipEventPayload.MTeam: GHAPIModelType {
  public static func == (lhs: MembershipEventPayload.MTeam, rhs: MembershipEventPayload.MTeam) -> Bool {
    return lhs.id == rhs.id
  }
  public static func decode(_ json: JSON) -> Decoded<MembershipEventPayload.MTeam> {
    return curry(MembershipEventPayload.MTeam.init)
      <^> json <| "name"
      <*> json <| "id"
      <*> json <| "slug"
      <*> json <| "permission"
      <*> json <| "url"
      <*> json <| "members_url"
      <*> json <| "repositories_url"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["name"] = self.name
    result["id"] = self.id
    result["slug"] = self.slug
    result["permission"] = self.permission
    result["url"] = self.url.absoluteString
    result["members_url"] = self.members_url.absoluteString
    result["repositories_url"] = self.repositories_url.absoluteString
    return result
  }
}
