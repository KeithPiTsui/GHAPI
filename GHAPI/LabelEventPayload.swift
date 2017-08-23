//
//  LabelEventPayload.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct LabelEventPayload: EventPayloadType{
  public struct LLabel {
    public let url: URL
    public let name: String
    public let color: String
  }
  public let action: String
  public let label: LabelEventPayload.LLabel
  public let repository: Repository
  public let organization: Organization
  public let sender: UserLite

}

extension LabelEventPayload: GHAPIModelType {
  public static func == (lhs: LabelEventPayload, rhs: LabelEventPayload) -> Bool {
    return lhs.action == rhs.action
      && lhs.label == rhs.label
      && lhs.repository == rhs.repository
      && lhs.organization == rhs.organization
      && lhs.sender == rhs.sender
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(LabelEventPayload.init)
      <^> json <| "action"
      <*> json <| "label"
      <*> json <| "repository"
      <*> json <| "organization"
      <*> json <| "sender"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["label"] = self.label.encode()
    result["repository"] = self.repository.encode()
    result["organization"] = self.organization.encode()
    result["sender"] = self.sender.encode()
    return result
  }
}
extension LabelEventPayload.LLabel: GHAPIModelType {
  public static func == (lhs: LabelEventPayload.LLabel, rhs: LabelEventPayload.LLabel) -> Bool {
    return lhs.url == rhs.url
  }
  public static func decode(_ json: JSON) -> Decoded<LabelEventPayload.LLabel> {
    return curry(LabelEventPayload.LLabel.init)
      <^> json <| "url"
      <*> json <| "name"
      <*> json <| "color"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["name"] = self.name
    result["color"] = self.color
    return result
  }
}
