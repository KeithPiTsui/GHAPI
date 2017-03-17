//
//  Organization.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct Organization {
  public let login: String
  public let id: UInt
  public let url: URL
  public let repos_url: URL
  public let events_url: URL
  public let hooks_url: URL?
  public let issues_url: URL?
  public let members_url: URL
  public let public_members_url: URL
  public let avatar_url: URL
  public let description: String?
}

extension Organization: GHAPIModelType {
  public static func == (lhs: Organization, rhs: Organization) -> Bool {
    return lhs.id == rhs.id
  }
  public static func decode(_ json: JSON) -> Decoded<Organization> {
    let creator = curry(Organization.init)
    let tmp = creator
      <^> json <| "login"
      <*> json <| "id"
      <*> json <| "url"
      <*> json <| "repos_url"
      <*> json <| "events_url"
    let tmp2 = tmp
      <*> json <|? "hooks_url"
      <*> json <|? "issues_url"
      <*> json <| "members_url"
    let tmp3 = tmp2
      <*> json <| "public_members_url"
      <*> json <| "avatar_url"
      <*> json <|? "description"
    return tmp3
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["id"] = self.id
    return result
  }
}
