/**
 A type that knows the location of a Kickstarter API and web server.
 */
public protocol ServerConfigType {
    var apiBaseUrl: URL { get }
    var webBaseUrl: URL { get }
    var apiClientAuth: ClientAuthType { get }
    var basicHTTPAuth: BasicHTTPAuthType? { get }
    var defaultHeaders: [String: String]? {get}
    var defaultParameters: [String: String]? {get}
}

public func == (lhs: ServerConfigType, rhs: ServerConfigType) -> Bool {
    return
        type(of: lhs) == type(of: rhs) &&
            lhs.apiBaseUrl == rhs.apiBaseUrl &&
            lhs.webBaseUrl == rhs.webBaseUrl &&
            lhs.apiClientAuth == rhs.apiClientAuth &&
            lhs.basicHTTPAuth == rhs.basicHTTPAuth
}

public struct ServerConfig: ServerConfigType {
    public let apiBaseUrl: URL
    public let webBaseUrl: URL
    public let apiClientAuth: ClientAuthType
    public let basicHTTPAuth: BasicHTTPAuthType?
    public let defaultHeaders: [String : String]?
    public let defaultParameters: [String : String]?
    
    public static let production: ServerConfigType = ServerConfig(
        apiBaseUrl: URL(string: "https://\(Secrets.Api.Endpoint.production)")!,
        webBaseUrl: URL(string: "https://\(Secrets.WebEndpoint.production)")!,
        apiClientAuth: ClientAuth.production,
        basicHTTPAuth: nil
    )
    
    public static let staging: ServerConfigType = ServerConfig(
        apiBaseUrl: URL(string: "https://\(Secrets.Api.Endpoint.staging)")!,
        webBaseUrl: URL(string: "https://\(Secrets.WebEndpoint.staging)")!,
        apiClientAuth: ClientAuth.development,
        basicHTTPAuth: BasicHTTPAuth.development
    )
    
    public static let local: ServerConfigType = ServerConfig(
        apiBaseUrl: URL(string: "http://api.ksr.dev")!,
        webBaseUrl: URL(string: "http://ksr.dev")!,
        apiClientAuth: ClientAuth.development,
        basicHTTPAuth: BasicHTTPAuth.development
    )
    
    public static let github: ServerConfigType = ServerConfig(
        apiBaseUrl: URL(string: "https://\(Secrets.Api.Endpoint.github)")!,
        webBaseUrl: URL(string: "https://\(Secrets.WebEndpoint.github)")!,
        apiClientAuth: ClientAuth.github,
        basicHTTPAuth: BasicHTTPAuth.github,
        defaultHeaders: ["Accept":"application/vnd.github.v3+json"]
    )
    
    public init(apiBaseUrl: URL,
                webBaseUrl: URL,
                apiClientAuth: ClientAuthType,
                basicHTTPAuth: BasicHTTPAuthType?,
                defaultHeaders: [String: String]? = nil,
                defaultParameters: [String: String]? = nil) {
        
        self.apiBaseUrl = apiBaseUrl
        self.webBaseUrl = webBaseUrl
        self.apiClientAuth = apiClientAuth
        self.basicHTTPAuth = basicHTTPAuth
        self.defaultHeaders = defaultHeaders
        self.defaultParameters = defaultParameters
    }
}














