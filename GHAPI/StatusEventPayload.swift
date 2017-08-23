//
//  StatusEventPayload.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct StatusEventPayload: EventPayloadType{
  public let id: UInt
  public let sha: String
  public let name: String
  public let target_url: URL?
  public let context: String
  public let desc: String?
  public let state: String
  public let commit: Commit
  public let branches: [BranchLite]
  public let created_at: Date
  public let updated_at: Date
  public let repository: Repository
  public let sender: UserLite
}

extension StatusEventPayload: GHAPIModelType {
  public static func == (lhs: StatusEventPayload, rhs: StatusEventPayload) -> Bool {
    return lhs.id == rhs.id
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    let creator = curry(StatusEventPayload.init) <^> json <| "id"
    let tmp = creator
    <*> json <| "sha"
    <*> json <| "name"
    <*> json <|? "target_url"
    <*> json <| "context"
    <*> json <|? "description"
    let tmp2 = tmp
    <*> json <| "state"
    <*> json <| "commit"
    <*> json <|| "branches"
    <*> json <| "created_at"
    <*> json <| "updated_at"
    let tmp3 = tmp2
    <*> json <| "repository"
    <*> json <| "sender"
    return tmp3.map{$0 as EventPayloadType}
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["id"] = self.id
    result["sha"] = self.sha
    result["name"] = self.name
    result["target_url"] = self.target_url?.absoluteString
    result["context"] = self.context
    result["description"] = self.desc
    result["state"] = self.state
    result["commit"] = self.commit.encode()
    result["branches"] = self.branches.map{$0.encode()}
    result["created_at"] = self.created_at.ISO8601DateRepresentation
    result["updated_at"] = self.updated_at.ISO8601DateRepresentation
    result["repository"] = self.repository.encode()
    result["sender"] = self.sender.encode()
    return result
  }
}
