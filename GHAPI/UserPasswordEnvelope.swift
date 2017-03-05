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

extension UserPasswordEnvelope: Decodable {
  public static func decode(_ json: JSON) -> Decoded<UserPasswordEnvelope> {
    return curry(UserPasswordEnvelope.init)
      <^> json <| "password"
      <*> json <| "user"
  }
}
