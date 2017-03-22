// swiftlint:disable file_length
// swiftlint:disable type_body_length

import Argo
import Foundation
import Prelude
import ReactiveExtensions
import ReactiveSwift

private extension Bundle {
  var _buildVersion: String {
    return (self.infoDictionary?["CFBundleVersion"] as? String) ?? "1"
  }
}

/**
 A `ServerType` that requests data from an API webservice.
 */
public struct Service: ServiceType {
  public let serverConfig: ServerConfigType

  public init(serverConfig: ServerConfigType = ServerConfig.github) { self.serverConfig = serverConfig }

  public func login(username: String, password: String)
    -> SignalProducer<(User,Service), ErrorEnvelope> {
      let serv = Service(serverConfig: ServerConfig.githubServerConfig(username: username, password: password))
      let me = serv.user(with: username).map{($0, serv)}
      return me
  }

  public func logout() -> Service { return Service() }

  public func user(with name: String) -> SignalProducer<User, ErrorEnvelope> {
    return request(.user(userName: name))
  }

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

  public func user(referredBy url: URL)
    -> SignalProducer<User, ErrorEnvelope> {
      return request(.resource(url: url))
  }

  public func repository(referredBy url: URL)
    -> SignalProducer<Repository, ErrorEnvelope> {
      return request(.resource(url: url))
  }

  public func repository(of ownername: String, and reponame: String)
    -> SignalProducer<Repository, ErrorEnvelope>{
      return request(.repository(username: ownername, reponame: reponame))
  }

  public func repositoryUrl(of ownername: String, and reponame: String) -> URL {
    return self.serverConfig.apiBaseUrl.appendingPathComponent(
      Route.repository(username: ownername, reponame: reponame).requestProperties.path)
  }

  public func contentURL(of ownername: String, and reponame: String, and branchname: String) -> URL {
    let repoURLStr = self.repositoryUrl(of: ownername, and: reponame).absoluteString
    let contentURLStr = "\(repoURLStr)/contents?ref=\(branchname)"
    return URL(string: contentURLStr)!
  }

  public func branchLites(referredBy url: URL) -> SignalProducer<[BranchLite], ErrorEnvelope> {
    return request(.resource(url: url))
  }

  public func branch(referredBy url: URL) -> SignalProducer<Branch, ErrorEnvelope> {
    return request(.resource(url: url))
  }

  public func commits(referredBy url: URL) -> SignalProducer<[Commit], ErrorEnvelope> {
    return request(.resource(url: url))
  }

  public func commit(referredBy url: URL)
    -> SignalProducer<Commit, ErrorEnvelope> {
      return request(.resource(url: url))
  }

  public func contents(referredBy url: URL)
    -> SignalProducer<[Content], ErrorEnvelope>{
      return request(.resource(url: url))
  }

  public func contents(of repository: Repository, ref branch: String? = nil)
    -> SignalProducer<[Content], ErrorEnvelope>{
      return request(.contents(repoURL: repository.urls.url, branch: branch))
  }

  public func contents(ofRepository url: URL, ref branch: String?)
    -> SignalProducer<[Content], ErrorEnvelope>{
      return request(.contents(repoURL: url, branch: branch))
  }

  public func readme(referredBy url: URL) -> SignalProducer<Readme, ErrorEnvelope> {
    return request(.resource(url: url))
  }
  public func events(of username: String) -> SignalProducer<[GHEvent], ErrorEnvelope> {
    return request(.events(userName: username))
  }

  public func receivedEvents(of username: String) -> SignalProducer<[GHEvent], ErrorEnvelope> {
    return request(.receivedEvents(userName: username))
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

extension Service {
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

  fileprivate static let session = URLSession(configuration: .default)

  fileprivate func requestPagination<M: Decodable>(_ paginationUrl: String)
    -> SignalProducer<M, ErrorEnvelope> where M == M.DecodedType {

      guard let paginationUrl = URL(string: paginationUrl) else {
        return .init(error: .invalidPaginationUrl)
      }

      return Service.session.rac_JSONResponse(preparedRequest(forURL: paginationUrl))
        .flatMap(decodeModel)
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
        preparedRequest(forURL: url, method: properties.method, query: properties.query),
        uploading: properties.file.map { ($1, $0.rawValue) }
        )
        .flatMap(decodeModels)
  }
  
  
}


