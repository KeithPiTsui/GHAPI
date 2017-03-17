//
//  DeleteEventPayload.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//


import Argo
import Curry
import Runes


public struct DeleteEventPayload: EventPayloadType{
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(DeleteEventPayload.init)
      <^> json <| "ref"
      <*> json <| "ref_type"
    <*> json <| "pusher_type"
    <*> json <| "repository"
    <*> json <| "sender"
  }

  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["ref"] = self.ref
    result["ref_type"] = self.ref_type
    result["pusher_type"] = self.pusher_type
    result["repository"] = self.repository.encode()
    result["sender"] = self.sender.encode()
    return result
  }

  public let ref: String
  public let ref_type: String
  public let pusher_type: String
  public let repository: Repository
  public let sender: UserLite
}

extension DeleteEventPayload: GHAPIModelType {
  public static func == (lhs: DeleteEventPayload, rhs: DeleteEventPayload) -> Bool {
    return lhs.ref == rhs.ref
    && lhs.ref_type == rhs.ref_type
    && lhs.pusher_type == rhs.pusher_type
    && lhs.repository == rhs.repository
    && lhs.sender == rhs.sender
  }
}
