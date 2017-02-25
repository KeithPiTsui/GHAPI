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

//extension UInt: Decodable {
//    /**
//     Decode `JSON` into `Decoded<UInt>`.
//     
//     Succeeds if the value is a number that can be converted to a `UInt`,
//     otherwise it returns a type mismatch.
//     
//     - parameter json: The `JSON` value to decode
//     
//     - returns: A decoded `UInt` value
//     */
//    public static func decode(_ json: JSON) -> Decoded<UInt> {
//        switch json {
//        case let .number(n): return pure(n.uintValue)
//        default: return .typeMismatch(expected: "UInt", actual: json)
//        }
//    }
//}

//let dateString = "Thu, 22 Oct 2015 07:45:17 +0000"
//let dateFormatter = NSDateFormatter()
//dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss +zzzz"
//dateFormatter.locale = Locale.init(identifier: "en_GB")
//let dateObj = dateFormatter.dateFromString(dateString)
//
//dateFormatter.dateFormat = "MM-dd-yyyy"
//print("Dateobj: \(dateFormatter.stringFromDate(dateObj!))")

extension Date: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Date> {
        switch json {
        case .string(let dateString):
            let df = DateFormatter()
            /// 2015-05-12T01:01:22Z
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            guard let date = df.date(from: dateString) else {
                return Decoded.failure(.custom("Date string misformatted"))
            }
            return pure(date)
        default: return .typeMismatch(expected: "Date", actual: json)
        }
    }
}


extension User: EncodableType {
  public func encode() -> [String:Any] {
    let result: [String:Any] = [:]
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
    return [ "url": self.url, "id": self.id]
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
        return [:]
    }
}
