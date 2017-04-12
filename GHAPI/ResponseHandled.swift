//
//  ResponseHandled.swift
//  GHAPI
//
//  Created by Pi on 12/04/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation

public enum ResponseHandled<Value> {
  case success(Value)
  case failure(ResponseHandleError)
}

extension ResponseHandled {
  public var value: Value? {
    if case let .success(value) = self {
      return value
    }
    return nil
  }
  public var error: ResponseHandleError? {
    if case let .failure(error) = self {
      return error
    }
    return nil
  }
}

public extension ResponseHandled {
  /**
   Convert a `Decoded` type into a `Decoded` `Optional` type.

   This is useful for when a decode operation should be allowed to fail, such
   as when decoding an optional property.

   - parameter x: A `Decoded` type

   - returns: The `Decoded` type with any failure converted to `.success(.none)`
   */
  static func optional<T>(_ x: ResponseHandled<T>) -> ResponseHandled<T?> {
    return .success(x.value)
  }

  /**
   Convert an `Optional` into a `Decoded` value.

   If the provided optional is `.Some`, this method extracts the value and
   wraps it in `.Success`. Otherwise, it returns a `.TypeMismatch` error.

   - returns: The provided `Optional` value transformed into a `Decoded` value
   */
  static func fromOptional<T>(_ x: T?) -> ResponseHandled<T> {
    switch x {
    case let .some(value): return .success(value)
    case .none: return .typeMismatch(expected: ".Some(\(T.self))", actual: ".None")
    }
  }
}

public extension ResponseHandled {
  /**
   Convenience function for creating `.TypeMismatch` errors.

   - parameter expected: A string describing the expected type
   - parameter actual: A string describing the actual type

   - returns: A `Decoded.Failure` with a `.TypeMismatch` error constructed
   from the provided `expected` and `actual` values
   */
  static func typeMismatch<T, U>(expected: String, actual: U) -> ResponseHandled<T> {
    return .failure(.typeMismatch(expected: expected, actual: String(describing: actual)))
  }

  /**
   Convenience function for creating `.MissingKey` errors.

   - parameter name: The name of the missing key

   - returns: A `Decoded.Failure` with a `.MissingKey` error constructed from
   the provided `name` value
   */
  static func missingKey<T>(_ name: String) -> ResponseHandled<T> {
    return .failure(.missingKey(name))
  }

  /**
   Convenience function for creating `.Custom` errors

   - parameter message: The custom error message

   - returns: A `Decoded.Failure` with a `.Custom` error constructed from the
   provided `message` value
   */
  static func customError<T>(_ message: String) -> ResponseHandled<T> {
    return .failure(.custom(message))
  }

  /**
   Convenience function for creating `.Multiple` errors

   - parameter errors: The errors

   - returns: A `Decoded.Failure` with a `.Multiple` error constructed from the
   provided `errors` value
   */
  static func multipleErrors<T>(errors: [ResponseHandleError]) -> ResponseHandled<T> {
    return .failure(.multiple(errors))
  }
}

extension ResponseHandled: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .success(value): return "Success(\(value))"
    case let .failure(error): return "Failure(\(error))"
    }
  }
}

public extension ResponseHandled {
  /**
   Extract the `.Success` value or throw an error.

   This can be used to move from `Decoded` types into the world of `throws`.
   If the value exists, this will return it. Otherwise, it will throw the error
   information.

   - throws: `DecodeError` if `self` is `.Failure`

   - returns: The unwrapped value
   */
  func dematerialize() throws -> Value {
    switch self {
    case let .success(value): return value
    case let .failure(error): throw error
    }
  }
}

/**
 Construct a `Decoded` type from a throwing function.

 This can be used to move from the world of `throws` into a `Decoded` type. If
 the function succeeds, it will wrap the returned value in a minimal context of
 `.Success`. Otherwise, it will return a custom error with the thrown error from
 the function.

 - parameter f: A function from `Void` to `T` that can `throw` an error

 - returns: A `Decoded` type representing the success or failure of the function
 */
public func materialize<T>(_ f: () throws -> T) -> ResponseHandled<T> {
  do {
    return .success(try f())
  } catch {
    return .customError("\(error)")
  }
}
