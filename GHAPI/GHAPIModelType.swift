//
//  GHAPIModelType.swift
//  GHAPI
//
//  Created by Pi on 13/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation
import Argo

public protocol GHAPIModelType:
  Equatable,
  CustomStringConvertible,
  CustomDebugStringConvertible,
  Decodable,
  EncodableType {

}

extension GHAPIModelType {
  public var description: String {
    return self.toJSONString() ?? ""
  }

  public var debugDescription: String {
    return self.toJSONString() ?? ""
  }
}
