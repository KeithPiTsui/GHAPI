//
//  GHEventEnvelope.swift
//  GHAPI
//
//  Created by Pi on 11/04/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct GHEventEnvelope {
  public let events: [GHEvent]
  public let links: PaginationLinks
}

extension GHEventEnvelope: GHAPIModelType {
  public static func == (lhs: GHEventEnvelope, rhs: GHEventEnvelope) -> Bool {
    return lhs.events == rhs.events
      && lhs.links == rhs.links
  }
  public static func decode(_ json: JSON) -> Decoded<GHEventEnvelope> {
    let creator = curry(GHEventEnvelope.init)
    let tmp = creator
      <^> json <|| "events"
      <*> json <| "links"
    return tmp
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["events"] = self.events.map{ $0.encode() }
    result["links"] = self.links.encode()
    return result
  }
}

public struct ItemEnvelope <Item: GHAPIModelType> {
  public let items: [Item]
  public let links: PaginationLinks
}

extension ItemEnvelope {
  public static var itemsKey: String { return "items" }
  public static var linksKey: String { return "links" }
}

extension ItemEnvelope: GHAPIModelType {
  public static func == (lhs: ItemEnvelope, rhs: ItemEnvelope) -> Bool {
    return lhs.items == rhs.items
      && lhs.links == rhs.links
  }
  public static func decode(_ json: JSON) -> Decoded<ItemEnvelope> {
    guard case let JSON.object(envelopeJson) = json,
    let itemsArrayJson = envelopeJson[ItemEnvelope.itemsKey],
    let linksJson = envelopeJson[ItemEnvelope.linksKey],
    case let JSON.array(itemsJson) = itemsArrayJson
      else {
        return Decoded.failure(.custom("Cannot retrieved item envelope json"))
    }

    let creator = curry(ItemEnvelope.init)
    let items = itemsJson.map{Item.decode($0).value as? Item}.compact()
    let liftedItems = Decoded.success(items)
    let links = PaginationLinks.decode(linksJson)
    return creator <^> liftedItems <*> links
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result[ItemEnvelope.itemsKey] = self.items.map{ $0.encode() }
    result[ItemEnvelope.linksKey] = self.links.encode()
    return result
  }
}


