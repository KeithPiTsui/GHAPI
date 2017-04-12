//
//  ResponseHandleable.swift
//  GHAPI
//
//  Created by Pi on 12/04/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation

public protocol ResponseHandleable {

  associatedtype HandledType = Self

  static func handle(_ response: HTTPURLResponse) -> ResponseHandled<HandledType>
}

public func handle<T: ResponseHandleable>(_ response: HTTPURLResponse)
  -> ResponseHandled<T>
  where T == T.HandledType {
    
  return T.handle(response)
}
