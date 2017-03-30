//
//  Release.swift
//  GHAPI
//
//  Created by Pi on 19/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

public struct Release {
  public struct RAsset {
    public let url: URL
    public let id: UInt
    public let label: String?
    public let uploader: UserLite
    public let content_type: String
    public let size: UInt
    public let download_count: UInt
    public let created_at: Date
    public let updated_at: Date
    public let browser_download_url: URL
  }

  public let url: URL
  public let assets_url: URL
  public let upload_url: URL
  public let html_url: URL
  public let id: UInt
  public let tag_name: String
  public let target_commitish: String
  public let name: String?
  public let draft: Bool
  public let author: UserLite
  public let prerelease: Bool
  public let created_at: Date
  public let published_at: Date
  public let assets: [RAsset]
  public let tarball_url: URL
  public let zipball_url: URL
  public let body: String?
}

extension Release: GHAPIModelType {
  public static func == (lhs: Release, rhs: Release) -> Bool {
    return lhs.url == rhs.url
  }
  public static func decode(_ json: JSON) -> Decoded<Release> {
    let tmp = curry(Release.init)
      <^> json <| "url"
      <*> json <| "assets_url"
    let tmp2 = tmp
      <*> json <| "upload_url"
      <*> json <| "html_url"
      <*> json <| "id"
      <*> json <| "tag_name"
    let tmp3 = tmp2
      <*> json <| "target_commitish"
      <*> json <|? "name"
      <*> json <| "draft"
      <*> json <| "author"
      <*> json <| "prerelease"
    let tmp4 = tmp3
      <*> json <| "created_at"
      <*> json <| "published_at"
      <*> json <|| "assets"
      <*> json <| "tarball_url"
      <*> json <| "zipball_url"
      <*> json <|? "body"
    return tmp4

  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["assets_url"] = self.assets_url.absoluteString
    result["upload_url"] = self.upload_url.absoluteString
    result["html_url"] = self.html_url.absoluteString
    result["id"] = self.id
    result["tag_name"] = self.tag_name
    result["target_commitish"] = self.target_commitish
    result["name"] = self.name
    result["draft"] = self.draft
    result["author"] = self.author.encode()
    result["prerelease"] = self.prerelease
    result["created_at"] = self.created_at.ISO8601DateRepresentation
    result["published_at"] = self.published_at.ISO8601DateRepresentation
    result["assets"] = self.assets.map{$0.encode()}
    result["tarball_url"] = self.tarball_url.absoluteString
    result["zipball_url"] = self.zipball_url.absoluteString
    result["body"] = self.body
    return result
  }
}

extension Release.RAsset: GHAPIModelType {
  public static func == (lhs: Release.RAsset, rhs: Release.RAsset) -> Bool {
    return lhs.url == rhs.url
  }

  /*
   public let url: URL
   public let id: UInt
   public let label: String?
   public let uploader: UserLite
   public let content_type: String
   public let size: UInt
   public let download_count: UInt
   public let created_at: Date
   public let updated_at: Date
   public let browser_download_url: URL
   */
  public static func decode(_ json: JSON) -> Decoded<Release.RAsset> {
    let tmp = curry(Release.RAsset.init)
      <^> json <| "url"
      <*> json <| "id"
    let tmp2 = tmp
      <*> json <|? "label"
      <*> json <| "uploader"
      <*> json <| "content_type"
      <*> json <| "size"
    let tmp3 = tmp2
      <*> json <| "download_count"
      <*> json <| "created_at"
      <*> json <| "updated_at"
      <*> json <| "browser_download_url"
    return tmp3

  }
  public func encode() -> [String : Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["id"] = self.id
    result["label"] = self.label
    result["uploader"] = self.uploader.encode()
    result["content_type"] = self.content_type
    result["size"] = self.size
    result["download_count"] = self.download_count
    result["created_at"] = self.created_at.ISO8601DateRepresentation
    result["updated_at"] = self.updated_at.ISO8601DateRepresentation
    result["browser_download_url"] = self.browser_download_url.absoluteString
    return result
  }
}





















