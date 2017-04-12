//
//  PaginationLinksResponseHandleable.swift
//  GHAPI
//
//  Created by Pi on 12/04/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation

extension PaginationLinks: ResponseHandleable {
  public static func handle(_ response: HTTPURLResponse) -> ResponseHandled<PaginationLinks> {
    if let links = PaginationLinks(response) {
      return ResponseHandled.success(links)
    } else {
      return ResponseHandled.failure(.custom("Cannot construct links"))
    }
  }
}

public struct GHResponseHeader {
  public let response: HTTPURLResponse
  public let links: PaginationLinks?
}

extension GHResponseHeader: ResponseHandleable {
  public static func handle(_ response: HTTPURLResponse) -> ResponseHandled<GHResponseHeader> {
    let links = PaginationLinks(response)
    return pure(GHResponseHeader(response: response, links: links))
  }
}
