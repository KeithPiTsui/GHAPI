//
//  Alternative.swift
//  GHAPI
//
//  Created by Pi on 12/04/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversFRP

/**
 Return the left `Decoded` value if it is `.Success`, otherwise return the
 default value on the right.

 - If the left hand side is `.Success`, this will return the argument on the
 left hand side.
 - If the left hand side is `.Failure`, this will return the argument on the
 right hand side.

 - parameter lhs: A value of type `Decoded<T>`
 - parameter rhs: A value of type `Decoded<T>`

 - returns: A value of type `Decoded<T>`
 */
public func <|> <T>(lhs: ResponseHandled<T>, rhs: @autoclosure () -> ResponseHandled<T>) -> ResponseHandled<T> {
  return lhs.or(rhs)
}

public extension ResponseHandled {
  /**
   Return `self` if it is `.Success`, otherwise return the provided default
   value.

   - If `self` is `.Success`, this will return `self`.
   - If `self` is `.Failure`, this will return the default.

   - parameter other: A value of type `Decoded<T>`

   - returns: A value of type `Decoded<T>`
   */
  func or(_ other: @autoclosure () -> ResponseHandled<Value>) -> ResponseHandled<Value> {
    switch self {
    case .success: return self
    case .failure: return other()
    }
  }
}
