//
//  SearchItemType.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public protocol SearchItemType {
  static func decode(_ json: JSON) -> Decoded<SearchItemType>
  func encode() -> [String:Any]
}

