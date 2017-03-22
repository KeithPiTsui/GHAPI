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


// MARK: Service extension of Service Type
extension Service {

  public func apiRoots()
    -> SignalProducer<GHAPIRoots, ErrorEnvelope> {
      return request(.apiRoots)
  }

  public func login(username: String, password: String)
    -> SignalProducer<(User,Service), ErrorEnvelope> {
      let serv = Service(serverConfig: ServerConfig.githubServerConfig(username: username, password: password))
      return serv.user(with: username).map{($0, serv)}
  }

  public func logout() -> Service { return Service() }

  // MARK: -
  // MARK: User Requesting

  public func user(with name: String)
    -> SignalProducer<User, ErrorEnvelope> {
      return request(.user(userName: name))
  }

  public func user(referredBy url: URL)
    -> SignalProducer<User, ErrorEnvelope> {
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
      return request(.search(scope: .repositories(qualifiers), keyword: keyword,  sort: sort, order: order))
  }

  public func searchUser(
    qualifiers: [UserQualifier],
    keyword: String? = nil,
    sort: SearchSorting? = nil,
    order: SearchSortingOrder? = nil)
    -> SignalProducer<SearchResult<User>, ErrorEnvelope> {
      return request(.search(scope: .users(qualifiers), keyword: keyword,  sort: sort, order: order))
  }


  // MARK: -
  // MARK: Repository Requesting
  public func repository(referredBy url: URL)
    -> SignalProducer<Repository, ErrorEnvelope> {
      return request(.resource(url: url))
  }

  public func repository(of ownername: String, and reponame: String)
    -> SignalProducer<Repository, ErrorEnvelope>{
      return request(.repository(username: ownername, reponame: reponame))
  }

  public func repositoryUrl(of ownername: String, and reponame: String) -> URL {
    guard let url = pureURL(of: .repository(username: ownername, reponame: reponame)) else {
      fatalError("Cannot construct a url of owner:\(ownername) and repo:\(reponame)")
    }
    return url
  }

  // MARK: -
  // MARK: Repository Content Requesting

  public func contents(referredBy url: URL)
    -> SignalProducer<[Content], ErrorEnvelope>{
      return request(.resource(url: url))
  }

  public func contents(of repository: Repository,
                       ref branch: String? = nil)
    -> SignalProducer<[Content], ErrorEnvelope>{
      return request(.contents(repo: repository, branch: branch))
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
        fatalError("Cannot construct a url of repo:\(repository.full_name) on branch:\(branch) ")
      }
      return url
  }

  // MARK: -
  // MARK: Branch and Commit Requesting
  public func branchLites(referredBy url: URL)
    -> SignalProducer<[BranchLite], ErrorEnvelope> {
      return request(.resource(url: url))
  }

  public func branch(referredBy url: URL)
    -> SignalProducer<Branch, ErrorEnvelope> {
      return request(.resource(url: url))
  }

  public func commits(referredBy url: URL)
    -> SignalProducer<[Commit], ErrorEnvelope> {
      return request(.resource(url: url))
  }

  public func commit(referredBy url: URL)
    -> SignalProducer<Commit, ErrorEnvelope> {
      return request(.resource(url: url))
  }

  // MARK: -
  // MARK: Others Requesting

  public func readme(referredBy url: URL) -> SignalProducer<Readme, ErrorEnvelope> {
    return request(.resource(url: url))
  }
  public func events(of user: User) -> SignalProducer<[GHEvent], ErrorEnvelope> {
    return request(.events(user:user))
  }

  public func receivedEvents(of user: User) -> SignalProducer<[GHEvent], ErrorEnvelope> {
    return request(.receivedEvents(user: user))
  }

  public func trendingRepository(of period: GithubCraper.TrendingPeriod, with language: String?)
    -> SignalProducer<[TrendingRepository], ErrorEnvelope> {
      return SignalProducer { observer, disposable in
        if let repos = GithubCraper.trendingRepositories(of: period, with: language) {
          observer.send(value: repos)
          observer.sendCompleted()
        } else {
          observer.send(error: .couldNotParseJSON)
        }
      }
  }

  public func data(of url: URL) -> SignalProducer<Data, ErrorEnvelope> {
    return SignalProducer { observer, disposable in
      if let data = try? Data(contentsOf: url) {
        observer.send(value: data)
        observer.sendCompleted()
      } else {
        observer.send(error: .networkError)
      }
    }
  }
}


// MARK: -
// MARK: Service Extension of Json decoding
extension Service {
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
extension Service {

  fileprivate static let session = URLSession(configuration: .default)

  fileprivate func requestPagination<M: Decodable>(_ paginationUrl: String)
    -> SignalProducer<M, ErrorEnvelope> where M == M.DecodedType {
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

  fileprivate func request<M: Decodable>(_ route: Route)
    -> SignalProducer<M, ErrorEnvelope> where M == M.DecodedType {
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

  fileprivate func request<M: Decodable>(_ route: Route)
    -> SignalProducer<[M], ErrorEnvelope> where M == M.DecodedType {
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





































