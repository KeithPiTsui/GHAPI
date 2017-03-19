//
//  ProjectCardEventPayload.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct ProjectCardEventPayload: EventPayloadType{
  public struct PProjectCard {
    public let url: URL
    public let column_url: URL
    public let column_id: UInt
    public let id: UInt
    public let note: String?
    public let creator: UserLite
    public let created_at: UInt
    public let updated_at: UInt
    public let content_url: URL
  }
  public let action: String
  public let project_card: ProjectCardEventPayload.PProjectCard
  public let repository: Repository
  public let organization: Organization
  public let sender: UserLite
}


extension ProjectCardEventPayload: GHAPIModelType {
  public static func == (lhs: ProjectCardEventPayload, rhs: ProjectCardEventPayload) -> Bool {
    return lhs.action == rhs.action
      && lhs.project_card == rhs.project_card
      && lhs.repository == rhs.repository
      && lhs.organization == rhs.organization
      && lhs.sender == rhs.sender
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(ProjectCardEventPayload.init)
      <^> json <| "action"
      <*> json <| "project_card"
      <*> json <| "repository"
      <*> json <| "organization"
      <*> json <| "sender"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["project_card"] = self.project_card.encode()
    result["repository"] = self.repository.encode()
    result["organization"] = self.organization.encode()
    result["sender"] = self.sender.encode()
    return result
  }
}

extension ProjectCardEventPayload.PProjectCard: GHAPIModelType {
  public static func == (lhs: ProjectCardEventPayload.PProjectCard, rhs: ProjectCardEventPayload.PProjectCard) -> Bool {
    return lhs.url == rhs.url
  }
  public static func decode(_ json: JSON) -> Decoded<ProjectCardEventPayload.PProjectCard> {
    return curry(ProjectCardEventPayload.PProjectCard.init)
      <^> json <| "url"
      <*> json <| "column_url"
      <*> json <| "column_id"
      <*> json <| "id"
      <*> json <|? "note"
      <*> json <| "creator"
      <*> json <| "created_at"
      <*> json <| "updated_at"
      <*> json <| "content_url"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["column_url"] = self.column_url.absoluteString
    result["column_id"] = self.column_id
    result["id"] = self.id
    result["note"] = self.note
    result["creator"] = self.creator.encode()
    result["created_at"] = self.created_at
    result["updated_at"] = self.updated_at
    result["content_url"] = self.content_url.absoluteString
    return result
  }
}
