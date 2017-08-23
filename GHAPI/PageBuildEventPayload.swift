//
//  PageBuildEventPayload.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversArgo
import PaversFRP


public struct PageBuildEventPayload: EventPayloadType{
  public struct PBuild {
    public struct PBError {
      public let message: String?
    }
    public let url: URL
    public let status: String
    public let error: PBError
    public let pusher: UserLite
    public let commit: String
    public let duration: UInt
    public let created_at: Date
    public let updated_at: Date

  }
  public let id: UInt
  public let build: PBuild
  public let repository: Repository
  public let sender: UserLite

}

extension PageBuildEventPayload: GHAPIModelType {
  public static func == (lhs: PageBuildEventPayload, rhs: PageBuildEventPayload) -> Bool {
    return lhs.id == rhs.id
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(PageBuildEventPayload.init)
      <^> json <| "id"
      <*> json <| "build"
      <*> json <| "repository"
      <*> json <| "sender"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["id"] = self.id
    return result
  }
}

extension PageBuildEventPayload.PBuild: GHAPIModelType {
  public static func == (lhs: PageBuildEventPayload.PBuild, rhs: PageBuildEventPayload.PBuild) -> Bool {
    return lhs.url == rhs.url
  }
  public static func decode(_ json: JSON) -> Decoded<PageBuildEventPayload.PBuild> {
    return curry(PageBuildEventPayload.PBuild.init)
      <^> json <| "url"
      <*> json <| "status"
      <*> json <| "error"
      <*> json <| "pusher"
      <*> json <| "commit"
      <*> json <| "duration"
      <*> json <| "created_at"
      <*> json <| "updated_at"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["status"] = self.status
    result["error"] = self.error.encode()
    result["pusher"] = self.pusher.encode()
    result["commit"] = self.commit
    result["duration"] = self.duration
    result["created_at"] = self.created_at.ISO8601DateRepresentation
    result["updated_at"] = self.updated_at.ISO8601DateRepresentation
    return result
  }
}

extension PageBuildEventPayload.PBuild.PBError: GHAPIModelType {
  public static func == (lhs: PageBuildEventPayload.PBuild.PBError, rhs: PageBuildEventPayload.PBuild.PBError) -> Bool {
    return lhs.message == rhs.message
  }
  public static func decode(_ json: JSON) -> Decoded<PageBuildEventPayload.PBuild.PBError> {
    return curry(PageBuildEventPayload.PBuild.PBError.init)
      <^> json <|? "message"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["message"] = self.message
    return result
  }
}
