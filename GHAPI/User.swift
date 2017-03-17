import Argo
import Curry
import Runes

public struct User {
  public struct URLs {
    public let url: URL
    public let htmlUrl: URL
    public let followersUrl: URL
    public let followingUrl: URL
    public let gitsUrl: URL
    public let starredUrl: URL
    public let subscriptionsUrl: URL
    public let organizationsUrl: URL
    public let reposUrl: URL
    public let eventsUrl: URL
    public let receivedEventsUrl: URL
  }

  public struct Avatar {
    public let url: URL
    public let id: String
  }

  public let login: String
  public let id: Int
  public let avatar: Avatar
  public let urls: User.URLs
  public let type: String
  public let siteAdmin: Bool

  public let name: String?
  public let company: String?
  public let blog: String?
  public let location: String?
  public let email: String?
  public let hireable: Bool?
  public let bio: String?
  public let publicRepos: Int?
  public let publicGists: Int?
  public let followers: Int?
  public let following: Int?
  public let createdDate: Date?
  public let updatedDate: Date?
}

extension User: GHAPIModelType {
  public static func == (lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id
  }

  public static func decode(_ json: JSON) -> Decoded<User> {
    let create = curry(User.init)
    let tmp = create
      <^> json <| "login"
      <*> json <| "id"

    let tmp1 = tmp
      <*> User.Avatar.decode(json)
      <*> User.URLs.decode(json)

    let tmp2 = tmp1
      <*> json <| "type"
      <*> json <| "site_admin"
      <*> json <|? "name"
      <*> json <|? "company"
      <*> json <|? "blog"

    let tmp3 = tmp2
      <*> json <|? "location"
      <*> json <|? "email"
      <*> json <|? "hireable"
      <*> json <|? "bio"
      <*> json <|? "public_repos"

    let tmp4 = tmp3
      <*> json <|? "public_gists"
      <*> json <|? "followers"
      <*> json <|? "following"
      <*> json <|? "created_at"
      <*> json <|? "updated_at"
    return tmp4
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["login"] = self.login
    result["id"] = self.id
    result = result.withAllValuesFrom(self.avatar.encode())
    result = result.withAllValuesFrom(self.urls.encode())
    result["type"] = self.type
    result["site_admin"] = self.siteAdmin
    result["name"] = self.name
    result["company"] = self.company ?? ""
    result["blog"] = self.blog ?? ""
    result["location"] = self.location
    result["email"] = self.email
    result["hireable"] = self.hireable ?? false
    result["bio"] = self.bio ?? ""
    result["public_repos"] = self.publicRepos
    result["public_gists"] = self.publicGists
    result["followers"] = self.followers
    result["following"] = self.following
    result["created_at"] = self.createdDate?.ISO8601DateRepresentation
    result["updated_at"] = self.updatedDate?.ISO8601DateRepresentation
    return result
  }

}

extension User.Avatar: GHAPIModelType {
  public static func == (lhs: User.Avatar, rhs: User.Avatar) -> Bool {
    return lhs.url == rhs.url
  }

  public static func decode(_ json: JSON) -> Decoded<User.Avatar> {
    return curry(User.Avatar.init)
      <^> json <| "avatar_url"
      <*> json <| "gravatar_id"
  }

  public func encode() -> [String:Any] {
    return [ "avatar_url": self.url.absoluteString, "gravatar_id": self.id]
  }
}

extension User.URLs: GHAPIModelType {

  public static func == (lhs: User.URLs, rhs: User.URLs) -> Bool {
    return lhs.url == rhs.url
  }

  public static func decode(_ json: JSON) -> Decoded<User.URLs> {
    let tmp = curry(User.URLs.init)
      <^> json <| "url"
      <*> json <| "html_url"
      <*> json <| "followers_url"
      <*> json <| "following_url"
      <*> json <| "gists_url"

    return tmp
      <*> json <| "starred_url"
      <*> json <| "subscriptions_url"
      <*> json <| "organizations_url"
      <*> json <| "repos_url"
      <*> json <| "events_url"
      <*> json <| "received_events_url"
  }

  public func encode() -> [String:Any] {
    var result: [String:Any] = [:]
    result["url"] = self.url.absoluteString
    result["html_url"] = self.htmlUrl.absoluteString
    result["followers_url"] = self.followersUrl.absoluteString
    result["following_url"] = self.followingUrl.absoluteString
    result["gists_url"] = self.gitsUrl.absoluteString
    result["starred_url"] = self.starredUrl.absoluteString
    result["subscriptions_url"] = self.subscriptionsUrl.absoluteString
    result["organizations_url"] = self.organizationsUrl.absoluteString
    result["repos_url"] = self.reposUrl.absoluteString
    result["events_url"] = self.eventsUrl.absoluteString
    result["received_events_url"] = self.receivedEventsUrl.absoluteString
    return result
  }
}

