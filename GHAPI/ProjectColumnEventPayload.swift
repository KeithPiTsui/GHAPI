//
//  ProjectColumnEventPayload.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct ProjectColumnEventPayload: EventPayloadType{
  public struct PProjectColumn {
    public let url: URL
    public let project_url: URL
    public let cards_url: URL
    public let id: UInt
    public let name: String
    public let created_at: UInt
    public let updated_at: UInt
  }
  public let action: String
  public let project_column: ProjectColumnEventPayload.PProjectColumn
  public let repository: Repository
  public let organization: Organization
  public let sender: UserLite
}

extension ProjectColumnEventPayload: GHAPIModelType {
  public static func == (lhs: ProjectColumnEventPayload, rhs: ProjectColumnEventPayload) -> Bool {
    return lhs.action == rhs.action
      && lhs.project_column == rhs.project_column
      && lhs.repository == rhs.repository
      && lhs.organization == rhs.organization
      && lhs.sender == rhs.sender
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(ProjectColumnEventPayload.init)
      <^> json <| "action"
    <*> json <| "project_column"
    <*> json <| "repository"
    <*> json <| "organization"
    <*> json <| "sender"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["project_column"] = self.project_column.encode()
    result["repository"] = self.repository.encode()
    result["organization"] = self.organization.encode()
    result["sender"] = self.sender.encode()
    return result
  }
}

extension ProjectColumnEventPayload.PProjectColumn: GHAPIModelType {
  public static func == (lhs: ProjectColumnEventPayload.PProjectColumn, rhs: ProjectColumnEventPayload.PProjectColumn) -> Bool {
    return lhs.url == rhs.url
  }
  public static func decode(_ json: JSON) -> Decoded<ProjectColumnEventPayload.PProjectColumn> {
    return curry(ProjectColumnEventPayload.PProjectColumn.init)
      <^> json <| "url"
      <*> json <| "project_url"
    <*> json <| "cards_url"
    <*> json <| "id"
    <*> json <| "name"
    <*> json <| "created_at"
    <*> json <| "updated_at"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["project_url"] = self.project_url.absoluteString
    result["cards_url"] = self.cards_url.absoluteString
    result["id"] = self.id
    result["name"] = self.name
    result["created_at"] = self.created_at
    result["updated_at"] = self.updated_at
    return result
  }
}
