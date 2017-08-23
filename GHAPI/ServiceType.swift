// swiftlint:disable file_length
import Foundation
import PaversFRP

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

  /// Returns roots of this api
  func apiRoots()
    -> SignalProducer<GHAPIRoots, ErrorEnvelope>

  /// Returns a new service with the user and password replaced
  func login(username: String, password: String)
    -> SignalProducer<(User,Service), ErrorEnvelope>

  /// Returns a new service without authentification infomation.
  func logout()
    -> Self

  /// Request user profile from github
  func user(with name: String)
    -> SignalProducer<User, ErrorEnvelope>

  func userURL(with name: String)
    -> URL

  func user(referredBy url: URL)
    -> SignalProducer<User, ErrorEnvelope>

  /// Request a search on Repository from github
  func searchRepository(
    qualifiers: [RepositoriesQualifier],
    keyword: String?,
    sort: SearchSorting?,
    order: SearchSortingOrder?)
    -> SignalProducer<SearchResult<Repository>, ErrorEnvelope>

  /// Request a search on User from github
  func searchUser(
    qualifiers: [UserQualifier],
    keyword: String?,
    sort: SearchSorting?,
    order: SearchSortingOrder?)
    -> SignalProducer<SearchResult<User>, ErrorEnvelope>


  /// Request a repository referred by url
  func repository(referredBy url: URL)
    -> SignalProducer<Repository, ErrorEnvelope>

  /// Request a repository specified by owner name and reop name
  func repository(of ownername: String, and reponame: String)
    -> SignalProducer<Repository, ErrorEnvelope>

  /// Compose a url for a repository specified by owner name and repo name
  func repositoryUrl(of ownername: String, and reponame: String)
    -> URL

  /// Compose a url for contents of a repository with specified branch
  func contentURL(of repository: Repository, ref branch: String?)
  -> URL

  func contentURL(of repository: URL, ref branch: String?) -> URL

  /// Request a content specified by url
  func contents(referredBy url: URL)
    -> SignalProducer<[Content], ErrorEnvelope>

  func contents(of repository: Repository, ref branch: String?)
    -> SignalProducer<[Content], ErrorEnvelope>

  func contents(ofRepository url: URL, ref branch: String?)
    -> SignalProducer<[Content], ErrorEnvelope>

  /// Request a list of branch brief specified by url
  ///
  /// As refered by branches url of repository
  func branchLites(referredBy url: URL)
    -> SignalProducer<[BranchLite], ErrorEnvelope>

  /// Request a specific branch specified by url
  func branch(referredBy url: URL)
    -> SignalProducer<Branch, ErrorEnvelope>

  /// Request a commit specified by url
  func commits(referredBy url: URL)
    -> SignalProducer<[Commit], ErrorEnvelope>

  /// Request a commit specified by url
  func commit(referredBy url: URL)
    -> SignalProducer<Commit, ErrorEnvelope>

  /// Commit comment
  func comments(of commit: Commit) -> SignalProducer<[CommitComment], ErrorEnvelope>

  /// Request a readme specified by url
  func readme(referredBy url: URL)
    -> SignalProducer<Readme, ErrorEnvelope>

  /// Request events of user
  func events(of user: User)
    -> SignalProducer<[GHEvent], ErrorEnvelope>

  /// Request received events of user
  func receivedEvents(of user: User)
    -> SignalProducer<[GHEvent], ErrorEnvelope>

  /// Request trending repositories specified with period and programming language
  func trendingRepository(
    of period: GithubCraper.TrendingPeriod,
    with language: String?)
    -> SignalProducer<[TrendingRepository], ErrorEnvelope>

  /// Request data specified by a url
  func data(of url: URL) -> SignalProducer<Data, ErrorEnvelope>

  /// Request an issue specified by a url
  func issue(of url: URL) -> SignalProducer<Issue, ErrorEnvelope>

  /// Request comments of an issue
  func issueComments(of issue: Issue) -> SignalProducer<[IssueComment], ErrorEnvelope>

  /// Request comments of a pull request
  func pullRequestComments(of pullRequest: PullRequest) -> SignalProducer<[IssueComment], ErrorEnvelope>

  /// Request forked repositories of a repo
  func forks(of repository: Repository) -> SignalProducer<[Repository], ErrorEnvelope>

  /// Request releases of a repo
  func releases(of repository: Repository) -> SignalProducer<[Release], ErrorEnvelope>

  /// Request events of a repo
  func events(of repository: Repository) -> SignalProducer<[GHEvent], ErrorEnvelope>

  /// Request events of a repo
  func contributors(of repository: Repository) -> SignalProducer<[UserLite], ErrorEnvelope>

  /// Request events of a repo
  func stargazers(of repository: Repository) -> SignalProducer<[UserLite], ErrorEnvelope>

  /// Pull Request events of a repo
  func pullRequests(of repository: Repository) -> SignalProducer<[PullRequest], ErrorEnvelope>

  /// Pull Request referred by an URL
  func pullRequest(of url: URL) -> SignalProducer<PullRequest, ErrorEnvelope>

  /// Request events of a repo
  func issues(of repository: Repository) -> SignalProducer<[Issue], ErrorEnvelope>

  func commits(of repository: Repository, on branch: BranchLite) -> SignalProducer<[Commit], ErrorEnvelope>

  func personalRepositories(of user: User) -> SignalProducer<[Repository], ErrorEnvelope>
//  func watchedRepositories(of user: User) -> SignalProducer<[Repository], ErrorEnvelope>
  func starredRepositories(of user: User) -> SignalProducer<[Repository], ErrorEnvelope>

//  func personalIssues(of user: User) -> SignalProducer<[Issue], ErrorEnvelope>
//  func personalPullRequests(of user: User) -> SignalProducer<[PullRequest], ErrorEnvelope>

  func receivedEventsWithResponseHeader(of url: URL)
    -> SignalProducer<GHServiceReturnType<[GHEvent]>, ErrorEnvelope>

  func receivedEventsWithResponseHeader(of user: User)
    -> SignalProducer<GHServiceReturnType<[GHEvent]>, ErrorEnvelope>
}

extension ServiceType {
  /// Returns `true` if an oauth token is present, and `false` otherwise.
  public var isAuthenticated: Bool { return self.serverConfig.basicHTTPAuth != nil}
}


// MARK: -
// MARK: ServiceType equality
public func == (lhs: ServiceType, rhs: ServiceType) -> Bool {
  return
    type(of: lhs) == type(of: rhs) &&
      lhs.serverConfig == rhs.serverConfig
}

public func != (lhs: ServiceType, rhs: ServiceType) -> Bool {
  return !(lhs == rhs)
}


// MARK: -
// MARK: ServiceType Request handling
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

      queryItems.append(contentsOf: self.defaultQueryParameters.map(URLQueryItem.init(name:value:)))

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
    var headers = self.serverConfig.defaultHeaders
    headers["Authorization"] = self.authorizationHeader
    return headers
  }

  fileprivate var defaultQueryParameters: [String: String] {
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
