// swiftlint:disable file_length
// swiftlint:disable type_body_length

import Argo
import Foundation
import Prelude
import ReactiveExtensions
import ReactiveSwift

/**
 A `ServerType` that requests data from an API webservice.
 */
public struct Service: ServiceType {
  public let serverConfig: ServerConfigType
  public init(serverConfig: ServerConfigType = ServerConfig.github) { self.serverConfig = serverConfig }
}


public typealias GHServiceReturnType<T> = (T, GHResponseHeader)

// MARK: Service extension of Service Type
extension Service {

  public func apiRoots() -> SignalProducer<GHAPIRoots, ErrorEnvelope> {
    return self.apiRootsWithResponseHeader().map(first)
  }

  public func apiRootsWithResponseHeader()
    -> SignalProducer<GHServiceReturnType<GHAPIRoots>, ErrorEnvelope> {
      return request(.apiRoots)
  }

  public func login(username: String, password: String)
    -> SignalProducer<(User,Service), ErrorEnvelope> {
      let serv = Service(serverConfig: ServerConfig.githubServerConfig(username: username, password: password))
      return serv.user(with: username).map{($0, serv)}
  }

  public func logout() -> Service { return Service() }
//
//  // MARK: -
//  // MARK: User Requesting
//
  public func user(with name: String)
    -> SignalProducer<User, ErrorEnvelope> {
      return self.userWithResponseHeader(with: name).map(first)
  }

  public func userWithResponseHeader(with name: String)
    -> SignalProducer<GHServiceReturnType<User>, ErrorEnvelope> {
      return request(.user(userName: name))
  }

  public func userURL(with name: String)
    -> URL{
      guard let url = self.pureURL(of: .user(userName: name)) else {
        fatalError("Cannot construct a url with username: \(name)")
      }
      return url
  }

  public func user(referredBy url: URL)
    -> SignalProducer<User, ErrorEnvelope> {
      return self.userWithResponseHeader(referredBy: url).map(first)
  }

  public func userWithResponseHeader(referredBy url: URL)
    -> SignalProducer<GHServiceReturnType<User>, ErrorEnvelope> {
      return request(.resource(url: url))
  }


  // MARK: -
  // MARK: Searching Requesting

  public func searchRepository(
    qualifiers: [RepositoriesQualifier],
    keyword: String? = nil,
    sort: SearchSorting? = nil,
    order: SearchSortingOrder? = nil)
    -> SignalProducer<SearchResult<Repository>, ErrorEnvelope> {
      return self.searchRepositoryWithResponseHeader(qualifiers: qualifiers, keyword: keyword, sort: sort, order: order)
        .map(first)
  }

  public func searchRepositoryWithResponseHeader(
    qualifiers: [RepositoriesQualifier],
    keyword: String? = nil,
    sort: SearchSorting? = nil,
    order: SearchSortingOrder? = nil)
    -> SignalProducer<GHServiceReturnType<SearchResult<Repository>>, ErrorEnvelope> {
      return request(.search(scope: .repositories(qualifiers), keyword: keyword,  sort: sort, order: order))
  }

  public func searchUser(
    qualifiers: [UserQualifier],
    keyword: String? = nil,
    sort: SearchSorting? = nil,
    order: SearchSortingOrder? = nil)
    -> SignalProducer<SearchResult<User>, ErrorEnvelope> {
      return self.searchUserWithResponseHeader(qualifiers: qualifiers, keyword: keyword, sort: sort, order: order)
        .map(first)
  }

  public func searchUserWithResponseHeader(
    qualifiers: [UserQualifier],
    keyword: String? = nil,
    sort: SearchSorting? = nil,
    order: SearchSortingOrder? = nil)
    -> SignalProducer<GHServiceReturnType<SearchResult<User>>, ErrorEnvelope> {
      return request(.search(scope: .users(qualifiers), keyword: keyword,  sort: sort, order: order))
  }


  // MARK: -
  // MARK: Repository Requesting
  public func repository(referredBy url: URL)
    -> SignalProducer<Repository, ErrorEnvelope> {
      return self.repositoryWithResponseHeader(referredBy: url).map(first)
  }

  public func repositoryWithResponseHeader(referredBy url: URL)
    -> SignalProducer<GHServiceReturnType<Repository>, ErrorEnvelope> {
      return request(.resource(url: url))
  }

  public func repository(of ownername: String, and reponame: String)
    -> SignalProducer<Repository, ErrorEnvelope>{
      return self.repositoryWithResponseHeader(of: ownername, and: reponame)
        .map(first)
  }

  public func repositoryWithResponseHeader(of ownername: String, and reponame: String)
    -> SignalProducer<GHServiceReturnType<Repository>, ErrorEnvelope>{
      return request(.repository(username: ownername, reponame: reponame))
  }


  public func repositoryUrl(of ownername: String, and reponame: String) -> URL {
    guard let url = pureURL(of: .repository(username: ownername, reponame: reponame)) else {
      fatalError("Cannot construct a url of owner:\(ownername) and repo:\(reponame)")
    }
    return url
  }

  public func personalRepositories(of user: User) -> SignalProducer<[Repository], ErrorEnvelope> {
    return self.personalRepositoriesWithResponseHeader(of: user).map(first)
  }

  public func personalRepositoriesWithResponseHeader(of user: User)
    -> SignalProducer<GHServiceReturnType<[Repository]>, ErrorEnvelope> {
    return request(.resource(url: user.urls.reposUrl))
  }

//  public func watchedRepositories(of user: User) -> SignalProducer<[Repository], ErrorEnvelope> {
//    return request(.resource(url: user.urls.starredUrl))
//  }
  public func starredRepositories(of user: User) -> SignalProducer<[Repository], ErrorEnvelope> {
    return self.starredRepositoriesWithResponseHeader(of: user).map(first)
  }

  public func starredRepositoriesWithResponseHeader(of user: User)
    -> SignalProducer<GHServiceReturnType<[Repository]>, ErrorEnvelope> {
    return request(.resource(url: user.urls.starredUrl))
  }


//  public func personalIssues(of user: User) -> SignalProducer<[Issue], ErrorEnvelope> {
//
//  }
//  public func personalPullRequests(of user: User) -> SignalProducer<[PullRequest], ErrorEnvelope> {
//
//  }


  public func forks(of repository: Repository) -> SignalProducer<[Repository], ErrorEnvelope> {
    return self.forksWithResponseHeader(of: repository).map(first)
  }

  public func forksWithResponseHeader(of repository: Repository) -> SignalProducer<GHServiceReturnType<[Repository]>, ErrorEnvelope> {
    return request(.resource(url: repository.urls.forks_url))
  }


  public func releases(of repository: Repository) -> SignalProducer<[Release], ErrorEnvelope> {
    return self.releasesWithResponseHeader(of: repository).map(first)
  }

  public func releasesWithResponseHeader(of repository: Repository) -> SignalProducer<GHServiceReturnType<[Release]>, ErrorEnvelope> {
    return request(.resource(url: repository.urls3.releases_url))
  }



  /// Request events of a repo
  public func events(of repository: Repository) -> SignalProducer<[GHEvent], ErrorEnvelope> {
    return self.eventsWithResponseHeader(of: repository).map(first)
  }

  public func eventsWithResponseHeader(of repository: Repository)
    -> SignalProducer<GHServiceReturnType<[GHEvent]>, ErrorEnvelope> {
    return request(.resource(url: repository.urls.events_url))
  }

  /// Request events of a repo
  public func contributors(of repository: Repository) -> SignalProducer<[UserLite], ErrorEnvelope> {
    return self.contributorsWithResponseHeader(of: repository).map(first)
  }

  public func contributorsWithResponseHeader(of repository: Repository)
    -> SignalProducer<GHServiceReturnType<[UserLite]>, ErrorEnvelope> {
    return request(.resource(url: repository.urls.contributors_url))
  }


  /// Request events of a repo
  public func stargazers(of repository: Repository) -> SignalProducer<[UserLite], ErrorEnvelope> {
    return self.stargazersWithResponseHeader(of: repository).map(first)
  }

  public func stargazersWithResponseHeader(of repository: Repository)
    -> SignalProducer<GHServiceReturnType<[UserLite]>, ErrorEnvelope> {
    return request(.resource(url: repository.urls3.stargazers_url))
  }

  /// Request events of a repo
  public func pullRequests(of repository: Repository) -> SignalProducer<[PullRequest], ErrorEnvelope> {
    return self.pullRequestsWithResponseHeader(of: repository).map(first)
  }

  public func pullRequestsWithResponseHeader(of repository: Repository)
    -> SignalProducer<GHServiceReturnType<[PullRequest]>, ErrorEnvelope> {
    return request(.resource(url: repository.urls3.pulls_url))
  }


  /// Request events of a repo
  public func issues(of repository: Repository) -> SignalProducer<[Issue], ErrorEnvelope> {
    return self.issuesWithResponseHeader(of: repository).map(first)
  }

  public func issuesWithResponseHeader(of repository: Repository)
    -> SignalProducer<GHServiceReturnType<[Issue]>, ErrorEnvelope> {
    return request(.resource(url: repository.urls2.issues_url))
  }


  // MARK: -
  // MARK: Repository Content Requesting

  public func contents(referredBy url: URL)
    -> SignalProducer<[Content], ErrorEnvelope>{
      return self.contentsWithResponseHeader(referredBy: url).map(first)
  }

  public func contentsWithResponseHeader(referredBy url: URL)
    -> SignalProducer<GHServiceReturnType<[Content]>, ErrorEnvelope>{
      return request(.resource(url: url))
  }


  public func contents(of repository: Repository,
                       ref branch: String? = nil)
    -> SignalProducer<[Content], ErrorEnvelope>{
      return self.contentsWithResponseHeader(of: repository, ref: branch).map(first)
  }

  public func contentsWithResponseHeader(of repository: Repository,
                       ref branch: String? = nil)
    -> SignalProducer<GHServiceReturnType<[Content]>, ErrorEnvelope>{
      return request(.contents(repo: repository, branch: branch))
  }


  public func contentURL(of repository: URL, ref branch: String?) -> URL {
    let contentURL = repository.appendingPathComponent("contents")
    var components = URLComponents(url: contentURL, resolvingAgainstBaseURL: true)
    let queryItem = URLQueryItem(name: "ref", value: branch)
    components?.queryItems = [queryItem]
    return (components?.url)!
  }

  public func contents(ofRepository url: URL,
                       ref branch: String? = nil)
    -> SignalProducer<[Content], ErrorEnvelope>{
      return self.repository(referredBy: url).concatMap { self.contents(of: $0) }
  }


  public func contentURL(of repository: Repository,
                         ref branch: String? = nil)
    -> URL {
      guard let url = pureURL(of: .contents(repo: repository, branch: branch)) else {
        fatalError("Cannot construct a url of repo:\(repository.full_name) on branch:\(String(describing: branch)) ")
      }
      return url
  }

  // MARK: -
  // MARK: Branch and Commit Requesting
  public func branchLites(referredBy url: URL)
    -> SignalProducer<[BranchLite], ErrorEnvelope> {
      return self.branchLitesWithResponseHeader(referredBy: url).map(first)
  }

  public func branchLitesWithResponseHeader(referredBy url: URL)
    -> SignalProducer<GHServiceReturnType<[BranchLite]>, ErrorEnvelope> {
      return request(.resource(url: url))
  }

  public func branch(referredBy url: URL)
    -> SignalProducer<Branch, ErrorEnvelope> {
      return self.branchWithResponseHeader(referredBy: url).map(first)
  }

  public func branchWithResponseHeader(referredBy url: URL)
    -> SignalProducer<GHServiceReturnType<Branch>, ErrorEnvelope> {
      return request(.resource(url: url))
  }


  public func commits(referredBy url: URL)
    -> SignalProducer<[Commit], ErrorEnvelope> {
      return self.commitsWithResponseHeader(referredBy: url).map(first)
  }

  public func commitsWithResponseHeader(referredBy url: URL)
    -> SignalProducer<GHServiceReturnType<[Commit]>, ErrorEnvelope> {
      return request(.resource(url: url))
  }

  public func commit(referredBy url: URL)
    -> SignalProducer<Commit, ErrorEnvelope> {
      return self.commitWithResponseHeader(referredBy: url).map(first)
  }

  public func commitWithResponseHeader(referredBy url: URL)
    -> SignalProducer<GHServiceReturnType<Commit>, ErrorEnvelope> {
      return request(.resource(url: url))
  }

  public func comments(of commit: Commit)
    -> SignalProducer<[CommitComment], ErrorEnvelope> {
      return self.commentsWithResponseHeader(of: commit).map(first)
  }

  public func commentsWithResponseHeader(of commit: Commit)
    -> SignalProducer<GHServiceReturnType<[CommitComment]>, ErrorEnvelope> {
      return request(.resource(url: commit.comments_url))
  }

  public func commits(of repository: Repository, on branch: BranchLite)
    -> SignalProducer<[Commit], ErrorEnvelope> {
      return self.commitsWithResponseHeader(of: repository, on: branch).map(first)
  }

  public func commitsWithResponseHeader(of repository: Repository, on branch: BranchLite)
    -> SignalProducer<GHServiceReturnType<[Commit]>, ErrorEnvelope> {
      return request(.commits(repo: repository, branch: branch))
  }

  // MARK: -
  // MARK: Others Requesting

  public func pullRequest(of url: URL) -> SignalProducer<PullRequest, ErrorEnvelope> {
    return self.pullRequestWithResponseHeader(of: url).map(first)
  }

  public func pullRequestWithResponseHeader(of url: URL)
    -> SignalProducer<GHServiceReturnType<PullRequest>, ErrorEnvelope> {
    return request(.resource(url: url))
  }


  public func readme(referredBy url: URL) -> SignalProducer<Readme, ErrorEnvelope> {
    return self.readmeWithResponseHeader(referredBy: url).map(first)
  }

  public func readmeWithResponseHeader(referredBy url: URL)
    -> SignalProducer<GHServiceReturnType<Readme>, ErrorEnvelope> {
    return request(.resource(url: url))
  }

  public func events(of user: User) -> SignalProducer<[GHEvent], ErrorEnvelope> {
    return self.eventsWithResponseHeader(of: user).map(first)
  }

  public func eventsWithResponseHeader(of user: User)
    -> SignalProducer<GHServiceReturnType<[GHEvent]>, ErrorEnvelope> {
    return request(.events(user:user))
  }


  public func receivedEvents(of user: User) -> SignalProducer<[GHEvent], ErrorEnvelope> {
    return self.receivedEventsWithResponseHeader(of: user).map(first)
  }

  public func receivedEventsWithResponseHeader(of user: User)
    -> SignalProducer<GHServiceReturnType<[GHEvent]>, ErrorEnvelope> {
    return request(.receivedEvents(user: user))
  }


  public func issue(of url: URL) -> SignalProducer<Issue, ErrorEnvelope> {
    return self.issueWithResponseHeader(of: url).map(first)
  }

  public func issueWithResponseHeader(of url: URL) -> SignalProducer<GHServiceReturnType<Issue>, ErrorEnvelope> {
    return request(.resource(url: url))
  }


  public func issueComments(of issue: Issue) -> SignalProducer<[IssueComment], ErrorEnvelope> {
    return self.issueCommentsWithResponseHeader(of: issue).map(first)
  }

  public func issueCommentsWithResponseHeader(of issue: Issue)
    -> SignalProducer<GHServiceReturnType<[IssueComment]>, ErrorEnvelope> {
    return request(.issueComments(issue: issue))
  }

  public func pullRequestComments(of pullRequest: PullRequest) -> SignalProducer<[IssueComment], ErrorEnvelope> {
    return self.pullRequestCommentsWithResponseHeader(of: pullRequest).map(first)
  }

  public func pullRequestCommentsWithResponseHeader(of pullRequest: PullRequest)
    -> SignalProducer<GHServiceReturnType<[IssueComment]>, ErrorEnvelope> {
    return request(.pullRequestComments(pullRequest: pullRequest))
  }



  public func trendingRepository(of period: GithubCraper.TrendingPeriod, with language: String?)
    -> SignalProducer<[TrendingRepository], ErrorEnvelope> {
      return SignalProducer { observer, disposable in
        if let repos = GithubCraper.trendingRepositories(of: period, with: language) {
          observer.send(value: repos)
          observer.sendCompleted()
        } else {
          observer.send(error: .noNetworkError)
        }
      }
  }

  public func data(of url: URL) -> SignalProducer<Data, ErrorEnvelope> {
    return SignalProducer { observer, disposable in
      do {
        let data = try Data(contentsOf: url)
        observer.send(value: data)
        observer.sendCompleted()
      } catch {
        let errorEnvelope
          = ErrorEnvelope(
            requestingPhase: .networking,
            errorType: .networkError,
            message: "Network Error",
            ghErrorEnvelope: nil,
            responseError: error,
            responseData: nil,
            response: nil)
        observer.send(error: errorEnvelope)
      }
    }
  }
}


// MARK: -
// MARK: Service Extension of Json decoding
extension Service {
  /// Decode json to get a model
  fileprivate func decodeModel<M: Decodable, N: ResponseHandleable>(_ responses: (json: Any, response: HTTPURLResponse)) ->
    SignalProducer<(M,N), ErrorEnvelope>
    where M == M.DecodedType, N == N.HandledType {

      let json = responses.json
      let response = responses.response

      return SignalProducer(value: (json, response))
        .map { (json, response) in return ((decode(json) as Decoded<M>), (N.handle(response) as ResponseHandled<N>)) }
        .flatMap(.concat) { (decoded: Decoded<M>, responded: ResponseHandled<N> ) -> SignalProducer<(M,N), ErrorEnvelope> in

          switch (decoded, responded) {
          case let (.success(value), .success(value2)):
            return .init(value: (value, value2))
          case let (.failure(error), _):
            print("Argo decoding model \(M.self) error: \(error)")
            return .init(error: .couldNotDecodeJSON(error))
          default:
            return .init(error: .unknownError)
          }
      }
  }

  /// Decode json to get an array of models
  fileprivate func decodeModels<M: Decodable, N: ResponseHandleable>(_ responses: (json: Any, response: HTTPURLResponse)) ->
    SignalProducer<([M],N), ErrorEnvelope> where M == M.DecodedType, N == N.HandledType {
      let json = responses.json
      let response = responses.response
      return SignalProducer(value: (json, response))
        .map { (json, response) in ((decode(json) as Decoded<[M]>), (N.handle(response) as ResponseHandled<N>)) }
        .flatMap(.concat) { (decoded: Decoded<[M]>, responded: ResponseHandled<N>) -> SignalProducer<([M],N), ErrorEnvelope> in
          switch (decoded, responded) {
          case let (.success(value) , .success(value2)):
            return .init(value: (value, value2))
          case let (.failure(error), _):
            print("Argo decoding model error: \(error)")
            return .init(error: .couldNotDecodeJSON(error))
          default:
            return .init(error: .unknownError)
          }
      }
  }
}

// MARK: -
// MARK: Service Extension of data requesting
extension Service {

  fileprivate static let session = URLSession(configuration: .default)

  fileprivate func requestPagination<M: Decodable, N: ResponseHandleable>(_ paginationUrl: String)
    -> SignalProducer<(M,N), ErrorEnvelope> where M == M.DecodedType, N == N.HandledType {
      guard let paginationUrl = URL(string: paginationUrl) else {
        return .init(error: .invalidPaginationUrl)
      }
      return Service.session
        .rac_JSONResponse(preparedRequest(forURL: paginationUrl))
        .flatMap(decodeModel)
  }

  fileprivate func pureRequest(of route: Route) -> URLRequest {
    let properties = route.requestProperties
    guard let URL = URL(string: properties.path, relativeTo: self.serverConfig.apiBaseUrl as URL) else {
      fatalError(
        "URL(string: \(properties.path), relativeToURL: \(self.serverConfig.apiBaseUrl)) == nil"
      )
    }
    return preparedRequest(forURL: URL,
                           method: properties.method,
                           query: properties.query,
                           headers: properties.headers)
  }

  fileprivate func pureURL(of route: Route) -> URL? {
    return self.pureRequest(of: route).url
  }

  fileprivate func request<M: Decodable, N: ResponseHandleable>(_ route: Route)
    -> SignalProducer<(M,N), ErrorEnvelope> where M == M.DecodedType, N == N.HandledType {
      let properties = route.requestProperties
      guard let URL = URL(string: properties.path, relativeTo: self.serverConfig.apiBaseUrl as URL) else {
        fatalError(
          "URL(string: \(properties.path), relativeToURL: \(self.serverConfig.apiBaseUrl)) == nil"
        )
      }
      return Service.session.rac_JSONResponse(
        preparedRequest(forURL: URL,
                        method: properties.method,
                        query: properties.query,
                        headers: properties.headers),
        uploading: properties.file.map { ($1, $0.rawValue) }
        )
        .flatMap(decodeModel)
  }

  fileprivate func request<M: Decodable, N: ResponseHandleable>(_ route: Route)
    -> SignalProducer<([M],N), ErrorEnvelope> where M == M.DecodedType, N == N.HandledType {
      let properties = route.requestProperties
      let url = self.serverConfig.apiBaseUrl.appendingPathComponent(properties.path)
      return Service.session.rac_JSONResponse(
        preparedRequest(forURL: url,
                        method: properties.method,
                        query: properties.query),
        uploading: properties.file.map { ($1, $0.rawValue) }
        )
        .flatMap(decodeModels)
  }
}





































