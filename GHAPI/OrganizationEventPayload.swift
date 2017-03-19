//
//  OrganizationEventPayload.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct OrganizationEventPayload: EventPayloadType{
  public struct OInvitation {
    public let id: UInt
    public let login: String
    public let email: String?
    public let role: String
  }
  public struct OMembership {
    public let url: URL
    public let state: String
    public let role: String
    public let organization_url: URL
    public let user: UserLite
  }
  public let action: String
  public let invitation: OInvitation
  public let membership: OMembership
  public let organization: Organization
  public let sender: UserLite


}

extension OrganizationEventPayload: GHAPIModelType {
  public static func == (lhs: OrganizationEventPayload, rhs: OrganizationEventPayload) -> Bool {
    return lhs.action == rhs.action
      && lhs.invitation == rhs.invitation
      && lhs.membership == rhs.membership
      && lhs.organization == rhs.organization
      && lhs.sender == rhs.sender
  }
  public static func decode(_ json: JSON) -> Decoded<EventPayloadType> {
    return curry(OrganizationEventPayload.init)
      <^> json <| "action"
      <*> json <| "invitation"
      <*> json <| "membership"
      <*> json <| "organization"
      <*> json <| "sender"

  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["action"] = self.action
    result["invitation"] = self.invitation.encode()
    result["membership"] = self.membership.encode()
    result["organization"] = self.organization.encode()
    result["sender"] = self.sender.encode()
    return result
  }
}

extension OrganizationEventPayload.OInvitation: GHAPIModelType {
  public static func == (lhs: OrganizationEventPayload.OInvitation, rhs: OrganizationEventPayload.OInvitation)
    -> Bool {
      return lhs.id == rhs.id
  }
  public static func decode(_ json: JSON) -> Decoded<OrganizationEventPayload.OInvitation> {
    return curry(OrganizationEventPayload.OInvitation.init)
      <^> json <| "id"
      <*> json <| "login"
      <*> json <|? "email"
      <*> json <| "role"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["id"] = self.id
    result["login"] = self.login
    result["email"] = self.email
    result["role"] = self.role
    return result
  }
}

extension OrganizationEventPayload.OMembership: GHAPIModelType {
  public static func == (lhs: OrganizationEventPayload.OMembership, rhs: OrganizationEventPayload.OMembership)
    -> Bool {
      return lhs.url == rhs.url
  }
  public static func decode(_ json: JSON) -> Decoded<OrganizationEventPayload.OMembership> {
    return curry(OrganizationEventPayload.OMembership.init)
      <^> json <| "url"
      <*> json <| "state"
      <*> json <| "role"
      <*> json <| "organization_url"
      <*> json <| "user"
  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["state"] = self.state
    result["role"] = self.role
    result["organization_url"] = self.organization_url.absoluteString
    result["user"] = self.user.encode()
    return result
  }
}








































