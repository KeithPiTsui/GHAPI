//
//  ReleaseEventPayload.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct ReleaseEventPayload: EventPayloadType{
  public let action: String
  public let release: Release
  public let repository: Repository?
  public let sender: UserLite?
}
extension ReleaseEventPayload: GHAPIModelType {
  public static func == (lhs: ReleaseEventPayload, rhs: ReleaseEventPayload) -> Bool {
    return lhs.action == rhs.action
      && lhs.release == rhs.release
      && lhs.repository == rhs.repository
      && lhs.sender == rhs.sender
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(ReleaseEventPayload.init)
      <^> json <| "action"
      <*> json <| "release"
      <*> json <|? "repository"
      <*> json <|? "sender"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["release"] = self.release.encode()
    result["repository"] = self.repository?.encode()
    result["sender"] = self.sender?.encode()
    return result
  }
}
