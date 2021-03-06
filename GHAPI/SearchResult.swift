//
//  SearchResult.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct SearchResult<I: GHAPIModelType> {
  public let total_count: Int
  public let incomplete_results: Bool
  public let items: [I]
}

extension SearchResult: GHAPIModelType {
  public static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.total_count == rhs.total_count
      && lhs.incomplete_results == rhs.incomplete_results
      && lhs.items == rhs.items
  }

  public static func decode(_ json: JSON) -> Decoded<SearchResult> {
    let items: Decoded<[I]>
    if case let .object(subJson) = json,
      let itemsJson = subJson["items"],
      case let .array(itemJsons) = itemsJson {
      let theseItems =
        itemJsons
          .map {I.decode($0).value as? I}
          .compact()
      items = Decoded.success(theseItems)
    } else {
      items = Decoded.failure(.custom("missing key items or cannot convert into data struct"))
    }

    return curry(SearchResult.init)
      <^> json <| "total_count"
      <*> json <| "incomplete_results"
      <*> items
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["total_count"] = self.total_count
    result["incomplete_results"] = self.incomplete_results
        result["items"] = self.items.map{$0.encode()}
    return result
  }
}
