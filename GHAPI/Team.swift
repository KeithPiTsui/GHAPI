//
//  Team.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct Team {
  public let name: String
  public let id: UInt
  public let slug: String
  public let privacy: String?
  public let permission: String
  public let url: URL
  public let members_url: URL
  public let repositories_url: URL
  public let desc: String?
}

extension Team: GHAPIModelType {
  public static func == (lhs: Team, rhs: Team) -> Bool {
    return lhs.id == rhs.id
  }
  public static func decode(_ json: JSON) -> Decoded<Team> {
    return curry(Team.init)
      <^> json <| "name"
      <*> json <| "id"
      <*> json <| "slug"
      <*> json <|? "privacy"
      <*> json <| "permission"
      <*> json <| "url"
      <*> json <| "members_url"
      <*> json <| "repositories_url"
      <*> json <|? "description"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["name"] = self.name
    result["id"] = self.id
    result["slug"] = self.slug
    result["description"] = self.desc
    result["privacy"] = self.privacy
    result["permission"] = self.permission
    result["url"] = self.url.absoluteString
    result["members_url"] = self.members_url.absoluteString
    result["repositories_url"] = self.repositories_url.absoluteString
    return result
  }
}
