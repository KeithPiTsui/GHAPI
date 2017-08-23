//
//  EventPayloadType.swift
//  GHAPI
//
//  Created by Pi on 13/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public protocol EventPayloadType {
  static func decode(_ json: JSON) -> Decoded<EventPayloadType>
  func encode() -> [String:Any]
}





































