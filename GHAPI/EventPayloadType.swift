//
//  EventPayloadType.swift
//  GHAPI
//
//  Created by Pi on 13/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public protocol EventPayloadType {
    static func decode(_ json: JSON) -> Decoded<EventPayloadType>
    func encode() -> [String:Any]
}





































