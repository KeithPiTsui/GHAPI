import Argo
import Curry
import Runes

public struct UserPasswordEnvelope {
    public let password: String
    public let user: User
    public init(password: String, user: User) {
        self.password = password
        self.user = user
    }
}

extension UserPasswordEnvelope: GHAPIModelType {
  public static func == (lhs: UserPasswordEnvelope, rhs: UserPasswordEnvelope) -> Bool {
    return lhs.user == rhs.user && lhs.password == rhs.password
  }
  public static func decode(_ json: JSON) -> Decoded<UserPasswordEnvelope> {
    return curry(UserPasswordEnvelope.init)
      <^> json <| "password"
      <*> json <| "user"
  }
  public func encode() -> [String : Any] {
    var result: [String : Any] = [:]
    result["user"] = self.user.encode()
    result["password"] = self.password
    return result
  }
}
