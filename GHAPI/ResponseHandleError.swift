//
//  ResponseHandleError.swift
//  GHAPI
//
//  Created by Pi on 12/04/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation

public enum ResponseHandleError: Error {
  /// The type existing at the key didn't match the type being requested.
  case typeMismatch(expected: String, actual: String)

  /// The key did not exist in the HTTPURLResponse.
  case missingKey(String)

  /// A custom error case for adding explicit failure info.
  case custom(String)

  /// There were multiple errors in the HTTPURLResponse.
  case multiple([ResponseHandleError])
}

extension ResponseHandleError: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .typeMismatch(expected, actual): return "TypeMismatch(Expected \(expected), got \(actual))"
    case let .missingKey(s): return "MissingKey(\(s))"
    case let .custom(s): return "Custom(\(s))"
    case let .multiple(es): return "Multiple(\(es.map { $0.description }.joined(separator: ", ")))"
    }
  }
}

extension ResponseHandleError: Hashable {
  public var hashValue: Int {
    switch self {
    case let .typeMismatch(expected: expected, actual: actual):
      return expected.hashValue ^ actual.hashValue
    case let .missingKey(string):
      return string.hashValue
    case let .custom(string):
      return string.hashValue
    case let .multiple(es):
      return es.reduce(0) { $0 ^ $1.hashValue }
    }
  }
}

public func == (lhs: ResponseHandleError, rhs: ResponseHandleError) -> Bool {
  switch (lhs, rhs) {
  case let (.typeMismatch(expected: expected1, actual: actual1), .typeMismatch(expected: expected2, actual: actual2)):
    return expected1 == expected2 && actual1 == actual2

  case let (.missingKey(string1), .missingKey(string2)):
    return string1 == string2

  case let (.custom(string1), .custom(string2)):
    return string1 == string2

  case let (.multiple(lhs), .multiple(rhs)):
    return lhs == rhs

  default:
    return false
  }
}

public func + (lhs: ResponseHandleError, rhs: ResponseHandleError) -> ResponseHandleError {
  switch (lhs, rhs) {
  case let (.multiple(es), e): return .multiple(es + [e])
  case let (e, .multiple(es)): return .multiple([e] + es)
  case let (le, re): return .multiple([le, re])
  }
}
