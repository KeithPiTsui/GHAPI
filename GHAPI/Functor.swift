//
//  Functor.swift
//  GHAPI
//
//  Created by Pi on 12/04/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Runes

/**
 Conditionally map a function over a `Decoded` value.

 - If the value is `.Failure`, the function will not be evaluated and this
 will return `.Failure`.
 - If the value is `.Success`, the function will be applied to the unwrapped
 value.

 - parameter f: A transformation function from type `T` to type `U`
 - parameter x: A value of type `Decoded<T>`

 - returns: A value of type `Decoded<U>`
 */
public func <^> <T, U>(f: (T) -> U, x: ResponseHandled<T>) -> ResponseHandled<U> {
  return x.map(f)
}

public extension ResponseHandled {
  /**
   Conditionally map a function over `self`.

   - If `self` is `.Failure`, the function will not be evaluated and this will
   return `.Failure`.
   - If `self` is `.Success`, the function will be applied to the unwrapped
   value.

   - parameter f: A transformation function from type `T` to type `U`

   - returns: A value of type `Decoded<U>`
   */
  func map<U>(_ f: (Value) -> U) -> ResponseHandled<U> {
    switch self {
    case let .success(value): return .success(f(value))
    case let .failure(error): return .failure(error)
    }
  }
}

