//
//  Applicative.swift
//  GHAPI
//
//  Created by Pi on 12/04/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversFRP

/**
 Conditionally apply a `Decoded` function to a `Decoded` value.

 - If either the function or value arguments are `.Failure`, this will return
 `.Failure`. The function's `.Failure` takes precedence here, and will be
 returned first. If the function is `.Success` and the value is `.Failure`,
 then the value's `.Failure` will be returned.
 - If both the function and value arguments are `.Success`, this will return
 the result of the function applied to the unwrapped value.

 - parameter f: A `Decoded` transformation function from type `T` to type `U`
 - parameter x: A value of type `Decoded<T>`

 - returns: A value of type `Decoded<U>`
 */
public func <*> <T, U>(f: ResponseHandled<(T) -> U>, x: ResponseHandled<T>) -> ResponseHandled<U> {
  return x.apply(f)
}

/**
 Wrap a value in the minimal context of `.Success`.

 - parameter x: Any value

 - returns: The provided value wrapped in `.Success`
 */
public func pure<T>(_ x: T) -> ResponseHandled<T> {
  return .success(x)
}

public extension ResponseHandled {
  /**
   Conditionally apply a `Decoded` function to `self`.

   - If either the function or `self` are `.Failure`, this will return
   `.Failure`. The function's `.Failure` takes precedence here, and will be
   returned first. If the function is `.Success` and `self` is `.Failure`,
   then `self`'s `.Failure` will be returned.
   - If both the function and `self` are `.Success`, this will return
   the result of the function applied to the unwrapped value.

   - parameter f: A `Decoded` transformation function from type `T` to type
   `U`

   - returns: A value of type `Decoded<U>`
   */
  func apply<U>(_ f: ResponseHandled<(Value) -> U>) -> ResponseHandled<U> {
    switch (f, self) {
    case let (.success(function), _): return self.map(function)
    case let (.failure(le), .failure(re)): return .failure(le + re)
    case let (.failure(f), _): return .failure(f)
    }
  }
}

