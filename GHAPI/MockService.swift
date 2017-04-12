//
//  MockService.swift
//  GHAPI
//
//  Created by Pi on 11/04/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Foundation
import Prelude
import ReactiveExtensions
import ReactiveSwift

/**
 A `ServerType` that requests data from an API webservice.
 */
public struct MockService: ServiceType {
   /// Returns a new service without authentification infomation.
  public func logout() -> MockService {
    return MockService()
  }

  public let serverConfig: ServerConfigType
  public init(serverConfig: ServerConfigType = ServerConfig.github) { self.serverConfig = serverConfig }

  fileprivate let user: User = .template

}


// MARK: Service extension of Service Type
extension MockService {

//  public func apiRoots()
//    -> SignalProducer<GHAPIRoots, ErrorEnvelope> {
//      return request(.apiRoots)
//  }
//
//  public func login(username: String, password: String)
//    -> SignalProducer<(User,Service), ErrorEnvelope> {
//      let serv = Service(serverConfig: ServerConfig.githubServerConfig(username: username, password: password))
//      return serv.user(with: username).map{($0, serv)}
//  }
//
//  public func logout() -> Service { return Service() }
//
//  // MARK: -
//  // MARK: User Requesting
//
//  public func user(with name: String)
//    -> SignalProducer<User, ErrorEnvelope> {
//      return SignalProducer(value: self.user |> User.lens.name .~ name)
//  }
//
//  public func userURL(with name: String)
//    -> URL{
//      guard let url = self.pureURL(of: .user(userName: name)) else {
//        fatalError("Cannot construct a url with username: \(name)")
//      }
//      return url
//  }
//
//  public func user(referredBy url: URL)
//    -> SignalProducer<User, ErrorEnvelope> {
//      let login = url.lastPathComponent
//      let name =  url.lastPathComponent
//      return SignalProducer(value: self.user |> User.lens.name .~ name |> User.lens.login .~ login)
//  }
//
//  // MARK: -
//  // MARK: Searching Requesting
//
//  public func searchRepository(
//    qualifiers: [RepositoriesQualifier],
//    keyword: String? = nil,
//    sort: SearchSorting? = nil,
//    order: SearchSortingOrder? = nil)
//    -> SignalProducer<SearchResult<Repository>, ErrorEnvelope> {
//      return request(.search(scope: .repositories(qualifiers), keyword: keyword,  sort: sort, order: order))
//  }
//
//  public func searchUser(
//    qualifiers: [UserQualifier],
//    keyword: String? = nil,
//    sort: SearchSorting? = nil,
//    order: SearchSortingOrder? = nil)
//    -> SignalProducer<SearchResult<User>, ErrorEnvelope> {
//      return request(.search(scope: .users(qualifiers), keyword: keyword,  sort: sort, order: order))
//  }
//
//
//  // MARK: -
//  // MARK: Repository Requesting
//  public func repository(referredBy url: URL)
//    -> SignalProducer<Repository, ErrorEnvelope> {
//      return request(.resource(url: url))
//  }
//
//  public func repository(of ownername: String, and reponame: String)
//    -> SignalProducer<Repository, ErrorEnvelope>{
//      return request(.repository(username: ownername, reponame: reponame))
//  }
//
//  public func repositoryUrl(of ownername: String, and reponame: String) -> URL {
//    guard let url = pureURL(of: .repository(username: ownername, reponame: reponame)) else {
//      fatalError("Cannot construct a url of owner:\(ownername) and repo:\(reponame)")
//    }
//    return url
//  }
//
//  public func personalRepositories(of user: User) -> SignalProducer<[Repository], ErrorEnvelope> {
//    return request(.resource(url: user.urls.reposUrl))
//  }
//  //  public func watchedRepositories(of user: User) -> SignalProducer<[Repository], ErrorEnvelope> {
//  //    return request(.resource(url: user.urls.starredUrl))
//  //  }
//  public func starredRepositories(of user: User) -> SignalProducer<[Repository], ErrorEnvelope> {
//    return request(.resource(url: user.urls.starredUrl))
//  }
//
//  //  public func personalIssues(of user: User) -> SignalProducer<[Issue], ErrorEnvelope> {
//  //
//  //  }
//  //  public func personalPullRequests(of user: User) -> SignalProducer<[PullRequest], ErrorEnvelope> {
//  //
//  //  }
//
//
//  public func forks(of repository: Repository) -> SignalProducer<[Repository], ErrorEnvelope> {
//    return request(.resource(url: repository.urls.forks_url))
//  }
//
//  public func releases(of repository: Repository) -> SignalProducer<[Release], ErrorEnvelope> {
//    return request(.resource(url: repository.urls3.releases_url))
//  }
//
//  /// Request events of a repo
//  public func events(of repository: Repository) -> SignalProducer<[GHEvent], ErrorEnvelope> {
//    return request(.resource(url: repository.urls.events_url))
//  }
//
//  /// Request events of a repo
//  public func contributors(of repository: Repository) -> SignalProducer<[UserLite], ErrorEnvelope> {
//    return request(.resource(url: repository.urls.contributors_url))
//  }
//
//  /// Request events of a repo
//  public func stargazers(of repository: Repository) -> SignalProducer<[UserLite], ErrorEnvelope> {
//    return request(.resource(url: repository.urls3.stargazers_url))
//  }
//
//  /// Request events of a repo
//  public func pullRequests(of repository: Repository) -> SignalProducer<[PullRequest], ErrorEnvelope> {
//    return request(.resource(url: repository.urls3.pulls_url))
//  }
//
//  /// Request events of a repo
//  public func issues(of repository: Repository) -> SignalProducer<[Issue], ErrorEnvelope> {
//    return request(.resource(url: repository.urls2.issues_url))
//  }
//
//  // MARK: -
//  // MARK: Repository Content Requesting
//
//  public func contents(referredBy url: URL)
//    -> SignalProducer<[Content], ErrorEnvelope>{
//      return request(.resource(url: url))
//  }
//
//  public func contents(of repository: Repository,
//                       ref branch: String? = nil)
//    -> SignalProducer<[Content], ErrorEnvelope>{
//      return request(.contents(repo: repository, branch: branch))
//  }
//
//  public func contentURL(of repository: URL, ref branch: String?) -> URL {
//    let contentURL = repository.appendingPathComponent("contents")
//    var components = URLComponents(url: contentURL, resolvingAgainstBaseURL: true)
//    let queryItem = URLQueryItem(name: "ref", value: branch)
//    components?.queryItems = [queryItem]
//    return (components?.url)!
//  }
//
//  public func contents(ofRepository url: URL,
//                       ref branch: String? = nil)
//    -> SignalProducer<[Content], ErrorEnvelope>{
//      return self.repository(referredBy: url).concatMap { self.contents(of: $0) }
//  }
//
//  public func contentURL(of repository: Repository,
//                         ref branch: String? = nil)
//    -> URL {
//      guard let url = pureURL(of: .contents(repo: repository, branch: branch)) else {
//        fatalError("Cannot construct a url of repo:\(repository.full_name) on branch:\(String(describing: branch)) ")
//      }
//      return url
//  }
//
//  // MARK: -
//  // MARK: Branch and Commit Requesting
//  public func branchLites(referredBy url: URL)
//    -> SignalProducer<[BranchLite], ErrorEnvelope> {
//      return request(.resource(url: url))
//  }
//
//  public func branch(referredBy url: URL)
//    -> SignalProducer<Branch, ErrorEnvelope> {
//      return request(.resource(url: url))
//  }
//
//  public func commits(referredBy url: URL)
//    -> SignalProducer<[Commit], ErrorEnvelope> {
//      return request(.resource(url: url))
//  }
//
//  public func commit(referredBy url: URL)
//    -> SignalProducer<Commit, ErrorEnvelope> {
//      return request(.resource(url: url))
//  }
//
//  public func comments(of commit: Commit)
//    -> SignalProducer<[CommitComment], ErrorEnvelope> {
//      return request(.resource(url: commit.comments_url))
//  }
//
//  public func commits(of repository: Repository, on branch: BranchLite)
//    -> SignalProducer<[Commit], ErrorEnvelope> {
//      return request(.commits(repo: repository, branch: branch))
//  }
//
//  // MARK: -
//  // MARK: Others Requesting
//
//  public func pullRequest(of url: URL) -> SignalProducer<PullRequest, ErrorEnvelope> {
//    return request(.resource(url: url))
//  }
//
//  public func readme(referredBy url: URL) -> SignalProducer<Readme, ErrorEnvelope> {
//    return request(.resource(url: url))
//  }
//  public func events(of user: User) -> SignalProducer<[GHEvent], ErrorEnvelope> {
//    return request(.events(user:user))
//  }
//
//  public func receivedEvents(of user: User) -> SignalProducer<[GHEvent], ErrorEnvelope> {
//    return request(.receivedEvents(user: user))
//  }
//
//  public func issue(of url: URL) -> SignalProducer<Issue, ErrorEnvelope> {
//    return request(.resource(url: url))
//  }
//
//  public func issueComments(of issue: Issue) -> SignalProducer<[IssueComment], ErrorEnvelope> {
//    return request(.issueComments(issue: issue))
//  }
//
//  public func pullRequestComments(of pullRequest: PullRequest) -> SignalProducer<[IssueComment], ErrorEnvelope> {
//    return request(.pullRequestComments(pullRequest: pullRequest))
//  }
//
//  public func trendingRepository(of period: GithubCraper.TrendingPeriod, with language: String?)
//    -> SignalProducer<[TrendingRepository], ErrorEnvelope> {
//      return SignalProducer { observer, disposable in
//        if let repos = GithubCraper.trendingRepositories(of: period, with: language) {
//          observer.send(value: repos)
//          observer.sendCompleted()
//        } else {
//          observer.send(error: .noNetworkError)
//        }
//      }
//  }
//
//  public func data(of url: URL) -> SignalProducer<Data, ErrorEnvelope> {
//    return SignalProducer { observer, disposable in
//      do {
//        let data = try Data(contentsOf: url)
//        observer.send(value: data)
//        observer.sendCompleted()
//      } catch {
//        let errorEnvelope
//          = ErrorEnvelope(
//            requestingPhase: .networking,
//            errorType: .networkError,
//            message: "Network Error",
//            ghErrorEnvelope: nil,
//            responseError: error,
//            responseData: nil,
//            response: nil)
//        observer.send(error: errorEnvelope)
//      }
//    }
//  }
}


// MARK: -
// MARK: Service Extension of Json decoding
extension MockService {
  /// Decode json to get a model
  fileprivate func decodeModel<M: Decodable>(_ json: Any) ->
    SignalProducer<M, ErrorEnvelope> where M == M.DecodedType {
      return SignalProducer(value: json)
        .map { json in decode(json) as Decoded<M> }
        .flatMap(.concat) { (decoded: Decoded<M>) -> SignalProducer<M, ErrorEnvelope> in
          switch decoded {
          case let .success(value):
            return .init(value: value)
          case let .failure(error):
            print("Argo decoding model \(M.self) error: \(error)")
            return .init(error: .couldNotDecodeJSON(error))
          }
      }
  }

  /// Decode json to get an array of models
  fileprivate func decodeModels<M: Decodable>(_ json: Any) ->
    SignalProducer<[M], ErrorEnvelope> where M == M.DecodedType {
      return SignalProducer(value: json)
        .map { json in decode(json) as Decoded<[M]> }
        .flatMap(.concat) { (decoded: Decoded<[M]>) -> SignalProducer<[M], ErrorEnvelope> in
          switch decoded {
          case let .success(value):
            return .init(value: value)
          case let .failure(error):
            print("Argo decoding model error: \(error)")
            return .init(error: .couldNotDecodeJSON(error))
          }
      }
  }
}

// MARK: -
// MARK: Service Extension of data requesting
extension MockService {

  fileprivate static let session = URLSession(configuration: .default)

  //  fileprivate func requestPagination<M: Decodable>(_ paginationUrl: String)
  //    -> SignalProducer<M, ErrorEnvelope> where M == M.DecodedType {
  //      guard let paginationUrl = URL(string: paginationUrl) else {
  //        return .init(error: .invalidPaginationUrl)
  //      }
  //      return Service.session
  //        .rac_JSONResponse(preparedRequest(forURL: paginationUrl))
  //        .flatMap(decodeModel)
  //  }

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

  fileprivate func request<M: Decodable>(_ route: Route)
    -> SignalProducer<M, ErrorEnvelope> where M == M.DecodedType {
      let properties = route.requestProperties
      guard let URL = URL(string: properties.path, relativeTo: self.serverConfig.apiBaseUrl as URL) else {
        fatalError(
          "URL(string: \(properties.path), relativeToURL: \(self.serverConfig.apiBaseUrl)) == nil"
        )
      }
      return MockService.session.rac_JSONResponse(
        preparedRequest(forURL: URL,
                        method: properties.method,
                        query: properties.query,
                        headers: properties.headers),
        uploading: properties.file.map { ($1, $0.rawValue) }
        )
        .flatMap(decodeModel)
  }

  fileprivate func request<M: Decodable>(_ route: Route)
    -> SignalProducer<[M], ErrorEnvelope> where M == M.DecodedType {
      let properties = route.requestProperties
      let url = self.serverConfig.apiBaseUrl.appendingPathComponent(properties.path)
      return MockService.session.rac_JSONResponse(
        preparedRequest(forURL: url,
                        method: properties.method,
                        query: properties.query),
        uploading: properties.file.map { ($1, $0.rawValue) }
        )
        .flatMap(decodeModels)
  }
}
