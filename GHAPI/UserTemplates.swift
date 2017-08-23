//
//  UserTemplates.swift
//  GHAPI
//
//  Created by Pi on 11/04/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversFRP

extension User.Avatar {
  internal static let template = User.template.avatar
}

extension User.URLs {
  internal static let template = User.template.urls
}

extension User {
  internal static let template: User = {
    guard
      let json = TemplateConstructionHelper.jsonObject(named: "User"),
      let temp = User.decode(json).value
      else { fatalError("Cannot construct template of User") }
    return temp
  }()
}
