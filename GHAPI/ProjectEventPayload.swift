//
//  ProjectEventPayload.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct ProjectEventPayload: EventPayloadType{
  public struct PProject {
    public let owner_url: URL
    public let url: URL
    public let columns_url: URL
    public let id: UInt
    public let name: String
    public let body: String
    public let number: UInt
    public let state: String
    public let creator: UserLite
    public let created_at: UInt
    public let updated_at: UInt
  }
  public let action: String
  public let project: ProjectEventPayload.PProject
  public let repository: Repository
  public let organization: Organization
  public let sender: UserLite
}

extension ProjectEventPayload: GHAPIModelType {
  public static func == (lhs: ProjectEventPayload, rhs: ProjectEventPayload) -> Bool {
    return lhs.action == rhs.action
      && lhs.project == rhs.project
      && lhs.repository == rhs.repository
      && lhs.organization == rhs.organization
      && lhs.sender == rhs.sender
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(ProjectEventPayload.init)
      <^> json <| "action"
      <*> json <| "project"
      <*> json <| "repository"
      <*> json <| "organization"
      <*> json <| "sender"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["project"] = self.project.encode()
    result["repository"] = self.repository.encode()
    result["organization"] = self.organization.encode()
    result["sender"] = self.sender.encode()
    return result
  }
}

extension ProjectEventPayload.PProject: GHAPIModelType {
  public static func == (lhs: ProjectEventPayload.PProject, rhs: ProjectEventPayload.PProject) -> Bool {
    return lhs.url == rhs.url
  }
  public static func decode(_ json: JSON) -> Decoded<ProjectEventPayload.PProject> {
    let creator = curry(ProjectEventPayload.PProject.init)
    let tmp = creator
      <^> json <| "owner_url"
      <*> json <| "url"
      <*> json <| "columns_url"
      <*> json <| "id"
      <*> json <| "name"
      <*> json <| "body"
    let tmp2 = tmp
      <*> json <| "number"
      <*> json <| "state"
      <*> json <| "creator"
      <*> json <| "created_at"
      <*> json <| "updated_at"

    return tmp2
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["owner_url"] = self.owner_url.absoluteString
    result["url"] = self.url.absoluteString
    result["columns_url"] = self.columns_url.absoluteString
    result["id"] = self.id
    result["name"] = self.name
    result["body"] = self.body
    result["number"] = self.number
    result["state"] = self.state
    result["creator"] = self.creator.encode()
    result["created_at"] = self.created_at
    result["updated_at"] = self.updated_at
    return result
  }
}
