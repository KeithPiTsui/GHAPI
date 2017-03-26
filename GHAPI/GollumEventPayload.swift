//
//  GollumEventPayload.swift
//  GHAPI
//
//  Created by Pi on 17/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes


public struct GollumEventPayload: EventPayloadType{
  public struct GPage {
    public let page_name: String
    public let title: String
    public let summary: String?
    public let action: String
    public let sha: String
    public let html_url: URL
  }
  public let pages: [GollumEventPayload.GPage]
  public let repository: Repository?
  public let sender: UserLite?
}

extension GollumEventPayload: GHAPIModelType {
  public static func == (lhs: GollumEventPayload, rhs: GollumEventPayload) -> Bool {
    return lhs.pages == rhs.pages
      && lhs.repository == rhs.repository
      && lhs.sender == rhs.sender
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(GollumEventPayload.init)
      <^> json <|| "pages"
      <*> json <|? "repository"
      <*> json <|? "sender"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["pages"] = self.pages.map{$0.encode()}
    result["repository"] = self.repository?.encode()
    result["sender"] = self.sender?.encode()
    return result
  }
}
extension GollumEventPayload.GPage: GHAPIModelType {
  public static func == (lhs: GollumEventPayload.GPage, rhs: GollumEventPayload.GPage) -> Bool {
    return lhs.sha == rhs.sha
  }
  public static func decode(_ json: JSON) -> Decoded<GollumEventPayload.GPage> {
    return curry(GollumEventPayload.GPage.init)
      <^> json <| "page_name"
      <*> json <| "title"
      <*> json <|? "summary"
      <*> json <| "action"
      <*> json <| "sha"
      <*> json <| "html_url"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["page_name"] = self.page_name
    result["title"] = self.title
    result["summary"] = self.summary
    result["action"] = self.action
    result["sha"] = self.sha
    result["html_url"] = self.html_url.absoluteString
    return result
  }
}
