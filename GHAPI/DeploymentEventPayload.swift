//
//  DeploymentEventPayload.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct DeploymentEventPayload: EventPayloadType{
  public let deployment: DDeployment
  public let repository: Repository
  public let sender: UserLite

  public struct DDeployment {
    public let url: URL
    public let id: UInt
    public let sha: String
    public let ref: String
    public let task: String
    public let environment: String
    public let desc: String
    public let creator: UserLite
    public let created_at: Date
    public let updated_at: Date
    public let statuses_url: URL
    public let repository_url: URL

  }
}

extension DeploymentEventPayload: GHAPIModelType {
  public static func == (lhs: DeploymentEventPayload, rhs: DeploymentEventPayload) -> Bool {
    return lhs.deployment == rhs.deployment
      && lhs.repository == rhs.repository
      && lhs.sender == rhs.sender
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(DeploymentEventPayload.init)
      <^> json <| "deployment"
      <*> json <| "repository"
      <*> json <| "sender"

  }

  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["deployment"] = self.deployment.encode()
    result["repository"] = self.repository.encode()
    result["sender"] = self.sender.encode()
    return result
  }
}

extension DeploymentEventPayload.DDeployment: GHAPIModelType {
  public static func == (lhs: DeploymentEventPayload.DDeployment, rhs: DeploymentEventPayload.DDeployment) -> Bool {
    return lhs.id == rhs.id
  }
  public static func decode(_ json: JSON) -> Decoded<DeploymentEventPayload.DDeployment> {
    let creator = curry(DeploymentEventPayload.DDeployment.init)
    let tmp = creator
      <^> json <| "url"
      <*> json <| "id"
      <*> json <| "sha"
      <*> json <| "ref"
      <*> json <| "task"
      <*> json <| "environment"
    let tmp2 = tmp
      <*> json <| "description"
      <*> json <| "creator"
      <*> json <| "created_at"
      <*> json <| "updated_at"
      <*> json <| "statuses_url"
      <*> json <| "repository_url"
    return tmp2

  }
  public func encode() -> [String : Any] {
    var result: [String : Any] = [:]
    result["url"] = self.url.absoluteString
    result["id"] = self.id
    result["sha"] = self.sha
    result["ref"] = self.ref
    result["task"] = self.task
    result["environment"] = self.environment
    result["description"] = self.desc
    result["creator"] = self.creator.encode()
    result["created_at"] = self.created_at.ISO8601DateRepresentation
    result["updated_at"] = self.updated_at.ISO8601DateRepresentation
    result["statuses_url"] = self.statuses_url.absoluteString
    result["repository_url"] = self.repository_url.absoluteString
    return result
  }
}
