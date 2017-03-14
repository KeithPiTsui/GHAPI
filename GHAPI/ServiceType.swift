// swiftlint:disable file_length
import Foundation
import Prelude
import ReactiveSwift

public enum Mailbox: String {
    case inbox
    case sent
}

/**
 A type that knows how to perform requests for Kickstarter data.
 */
public protocol ServiceType {
    var serverConfig: ServerConfigType { get }
    
    init( serverConfig: ServerConfigType)
    
    /// Returns a new service with the user and password replaced
    func login(username: String, password: String) -> Service
    
    /// Returns a new service without authentification infomation.
    func logout() -> Self
    
    /// Request to test with Github API
    func testConnectionToGithub() -> SignalProducer<User, ErrorEnvelope>
    
    /// Request user profile from github
    func userProfile(name: String) -> SignalProducer<User, ErrorEnvelope>
    
    /// Request a search on Repository from github
    func searchRepository(qualifiers: [RepositoriesQualifier],
                          keyword: String?,
                          sort: SearchSorting?,
                          order: SearchSortingOrder?) ->  SignalProducer<RepositorySearchResult, ErrorEnvelope>
    
    /// Request a search on Repository from github
    func searchUser(qualifiers: [UserQualifier],
                          keyword: String?,
                          sort: SearchSorting?,
                          order: SearchSortingOrder?) ->  SignalProducer<UserSearchResult, ErrorEnvelope>
    
    func user(referredBy url: URL) -> SignalProducer<User, ErrorEnvelope>
    
    func repository(referredBy url: URL) -> SignalProducer<Repository, ErrorEnvelope>
    
    func branches(referredBy url: URL) -> SignalProducer<[Branch], ErrorEnvelope>
    
    func commits(referredBy url: URL) -> SignalProducer<[Commit], ErrorEnvelope>
    
    func readme(referredBy url: URL) -> SignalProducer<Readme, ErrorEnvelope>
    
    func events(of user: User) -> SignalProducer<[GHEvent], ErrorEnvelope>
    
    func trendingRepository(of period: GithubCraper.TrendingPeriod, with language: String?) -> SignalProducer<[TrendingRepository], ErrorEnvelope>
}

extension ServiceType {
    /// Returns `true` if an oauth token is present, and `false` otherwise.
    public var isAuthenticated: Bool { return self.serverConfig.basicHTTPAuth != nil}
}

public func == (lhs: ServiceType, rhs: ServiceType) -> Bool {
    return
        type(of: lhs) == type(of: rhs) &&
            lhs.serverConfig == rhs.serverConfig
}

public func != (lhs: ServiceType, rhs: ServiceType) -> Bool {
    return !(lhs == rhs)
}

extension ServiceType {
    
    /**
     Prepares a URL request to be sent to the server.
     
     - parameter originalRequest: The request that should be prepared.
     - parameter query:           Additional query params that should be attached to the request.
     
     - returns: A new URL request that is properly configured for the server.
     */
    public func preparedRequest(forRequest originalRequest: URLRequest,
                                query: [String:Any] = [:],
                                headers: [String: String] = [:])
        -> URLRequest {
            
            var request = originalRequest
            guard let URL = request.url else { return originalRequest }
            
            var thisHeaders = self.defaultHeaders
            if headers.isEmpty == false {
                thisHeaders = thisHeaders.withAllValuesFrom(headers)
            }
            
            let method = request.httpMethod?.uppercased()
            var components = URLComponents(url: URL, resolvingAgainstBaseURL: false)!
            var queryItems = components.queryItems ?? []
            
            if let defaultQPs = self.defaultQueryParameters {
                queryItems.append(contentsOf: defaultQPs.map(URLQueryItem.init(name:value:)))
            }
            
            if method == .some("POST") || method == .some("PUT")
            || method == .some("PATCH") || method == .some("DELETE") {
                if request.httpBody == nil {
                    thisHeaders["Content-Type"] = "application/json; charset=utf-8"
                    request.httpBody = try? JSONSerialization.data(withJSONObject: query, options: [])
                }
            } else {
                queryItems.append(contentsOf: query.flatMap(queryComponents).map(URLQueryItem.init(name:value:)))
            }
            if queryItems.count > 0 {
                components.queryItems = queryItems.sorted { $0.name < $1.name }
                request.url = components.url
            }
            
            let currentHeaders = request.allHTTPHeaderFields ?? [:]
            request.allHTTPHeaderFields = currentHeaders.withAllValuesFrom(thisHeaders)
            
            return request
    }
    
    /**
     Prepares a request to be sent to the server.
     
     - parameter URL:    The URL to turn into a request and prepare.
     - parameter method: The HTTP verb to use for the request.
     - parameter query:  Additional query params that should be attached to the request.
     
     - returns: A new URL request that is properly configured for the server.
     */
    public func preparedRequest(forURL url: URL,
                                method: Method = .GET,
                                query: [String:Any] = [:],
                                headers: [String: String] = [:])
        -> URLRequest {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            return self.preparedRequest(forRequest: request, query: query, headers: headers)
    }
    
    public func isPrepared(request: URLRequest) -> Bool {
        return request.value(forHTTPHeaderField: "Authorization") == authorizationHeader
    }
    
    fileprivate var defaultHeaders: [String:String]  {
        var headers = self.serverConfig.defaultHeaders ?? [:]
        headers["Authorization"] = self.authorizationHeader
        return headers
    }
    
    fileprivate var defaultQueryParameters: [String: String]? {
        return self.serverConfig.defaultParameters
    }
    
    fileprivate var authorizationHeader: String? {
            return self.serverConfig.basicHTTPAuth?.authorizationHeader
    }
    
    
    fileprivate func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String:Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else {
            components.append((key, String(describing: value)))
        }
        
        return components
    }
}
// swiftlint:enable file_length
