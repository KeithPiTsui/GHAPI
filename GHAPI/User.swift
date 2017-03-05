import Argo
import Curry
import Runes

public struct User {
    public struct URLs {
        public let url: String
        public let htmlUrl: String
        public let followersUrl: String
        public let followingUrl: String
        public let gitsUrl: String
        public let starredUrl: String
        public let subscriptionsUrl: String
        public let organizationsUrl: String
        public let reposUrl: String
        public let eventsUrl: String
        public let receivedEventsUrl: String
    }
    
    public struct Avatar {
        public let url: String
        public let id: String
    }
    
    public let login: String
    public let id: Int
    public let avatar: Avatar
    public let urls: URLs
    public let type: String
    public let siteAdmin: Bool
    public let name: String
    public let company: String?
    public let blog: String?
    public let location: String
    public let email: String
    public let hireable: Bool?
    public let bio: String?
    public let publicRepos: Int
    public let publicGists: Int
    public let followers: Int
    public let following: Int
    public let createdDate: Date
    public let updatedDate: Date
    
    
}

extension User: Equatable {}
public func == (lhs: User, rhs: User) -> Bool {
  return lhs.id == rhs.id
}

extension User: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "User(id: \(id), name: \"\(name)\")"
  }
}

extension User: Decodable {
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
        <*> json <| "name"
        <*> json <|? "company"
        <*> json <|? "blog"
    
    let tmp3 = tmp2
        <*> json <| "location"
        <*> json <| "email"
        <*> json <|? "hireable"
        <*> json <|? "bio"
        <*> json <| "public_repos"
        
    let tmp4 = tmp3
        <*> json <| "public_gists"
        <*> json <| "followers"
        <*> json <| "following"
        <*> json <| "created_at"
        <*> json <| "updated_at"
    
    return tmp4

  }
}
extension Date: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Date> {
        switch json {
        case .string(let dateString):
            guard let date = ISO8601DateFormatter().date(from: dateString) else { return .failure(.custom("Date string misformatted"))}
            return pure(date)
        default: return .typeMismatch(expected: "Date", actual: json)
        }
    }
    
    public var ISO8601DateRepresentation: String {
        return ISO8601DateFormatter().string(from: self)
    }
}


extension User: EncodableType {
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
    result["created_at"] = self.createdDate.ISO8601DateRepresentation
    result["updated_at"] = self.updatedDate.ISO8601DateRepresentation
    return result
  }
}

extension User.Avatar: Decodable {
  public static func decode(_ json: JSON) -> Decoded<User.Avatar> {
    return curry(User.Avatar.init)
      <^> json <| "avatar_url"
      <*> json <| "gravatar_id"
  }
}

extension User.Avatar: EncodableType {
  public func encode() -> [String:Any] {
    return [ "avatar_url": self.url, "gravatar_id": self.id]
  }
}

extension User.URLs: Decodable {
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
}

extension User.URLs: EncodableType {
    public func encode() -> [String:Any] {
        var result: [String:Any] = [:]
        result["url"] = self.url
        result["html_url"] = self.htmlUrl
        result["followers_url"] = self.followersUrl
        result["following_url"] = self.followingUrl
        result["gists_url"] = self.gitsUrl
        result["starred_url"] = self.starredUrl
        result["subscriptions_url"] = self.subscriptionsUrl
        result["organizations_url"] = self.organizationsUrl
        result["repos_url"] = self.reposUrl
        result["events_url"] = self.eventsUrl
        result["received_events_url"] = self.receivedEventsUrl
        return result
    }
}
