/**
 A type that knows the location of a Kickstarter API and web server.
 */
public protocol ServerConfigType {
    var apiBaseUrl: URL { get }
    var basicHTTPAuth: BasicHTTPAuthType? { get }
    var defaultHeaders: [String: String]? {get}
    var defaultParameters: [String: String]? {get}
}

public func == (lhs: ServerConfigType, rhs: ServerConfigType) -> Bool {
    return
        type(of: lhs) == type(of: rhs) &&
            lhs.apiBaseUrl == rhs.apiBaseUrl &&
            lhs.basicHTTPAuth == rhs.basicHTTPAuth
}

public struct ServerConfig: ServerConfigType {
    public let apiBaseUrl: URL
    public let basicHTTPAuth: BasicHTTPAuthType?
    public let defaultHeaders: [String : String]?
    public let defaultParameters: [String : String]?
    
    
    public static let github: ServerConfigType = ServerConfig(
        apiBaseUrl: URL(string: "https://\(Secrets.Api.Endpoint.github)")!,
        defaultHeaders: ["Accept":"application/vnd.github.v3+json"]
    )
    
    
    public static func githubServerConfig(username: String, password: String) -> ServerConfigType {
        return ServerConfig(
            apiBaseUrl: URL(string: "https://\(Secrets.Api.Endpoint.github)")!,
            basicHTTPAuth: BasicHTTPAuth(username: username, password: password),
            defaultHeaders: ["Accept":"application/vnd.github.v3+json"]
        )
    }
    
    public init(apiBaseUrl: URL,
                basicHTTPAuth: BasicHTTPAuthType? = nil,
                defaultHeaders: [String: String]? = nil,
                defaultParameters: [String: String]? = ["per_page":"5"]) {
        self.apiBaseUrl = apiBaseUrl
        self.basicHTTPAuth = basicHTTPAuth
        self.defaultHeaders = defaultHeaders
        self.defaultParameters = defaultParameters
    }
}














