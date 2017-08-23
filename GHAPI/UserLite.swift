//
//  LiteUser.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct UserLite {
  public let login: String
  public let id: UInt
  public let avatar: User.Avatar
  public let urls: User.URLs
  public let type: String
  public let site_admin: Bool

  public static func decode(_ json: JSON) -> Decoded<UserLite> {
    return
      curry(UserLite.init)
        <^> json <| "login"
        <*> json <| "id"
        <*> User.Avatar.decode(json)
        <*> User.URLs.decode(json)
        <*> json <| "type"
        <*> json <| "site_admin"

  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result = result.withAllValuesFrom(self.urls.encode())
    result = result.withAllValuesFrom(self.avatar.encode())
    result["login"] = self.login
    result["id"] = self.id
    result["type"] = self.type
    result["site_admin"] = self.site_admin
    return result
  }
}

extension UserLite: GHAPIModelType {
  public static func == (lhs: UserLite, rhs: UserLite) -> Bool {
    return lhs.id == rhs.id
  }
}
