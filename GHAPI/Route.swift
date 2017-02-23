import Prelude

/**
 A list of possible requests that can be made for Kickstarter data.
 */
internal enum Route {
    case user(userName: String)
    enum UploadParam: String {
        case image
        case video
    }

  // swiftlint:disable:next large_tuple
    internal var requestProperties: (
        method: Method,
        path: String,
        query: [String:Any],
        file: (name: UploadParam, url: URL)?) {
        
        switch self {
        case let .user(userName):
            return (.GET, "/users/\(userName)", [:], nil)
        }
    }
}
