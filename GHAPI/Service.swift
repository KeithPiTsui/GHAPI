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
    
    public func login(username: String, password: String) -> Service {
        return Service(serverConfig: ServerConfig.githubServerConfig(username: username, password: password))
    }
    
    public func logout() -> Service { return Service() }
    
    public func testConnectionToGithub() -> SignalProducer<User, ErrorEnvelope> {
        return request(.user(userName: "keithpitsui"))
    }
    
    public func userProfile(name: String) -> SignalProducer<User, ErrorEnvelope> {
        return request(.user(userName: name))
    }
    
    public func search(scope: SearchScope,
                       keyword: String,
                       sort: SearchSorting? = nil,
                       order: SearchSortingOrder? = nil) -> SignalProducer<SearchResult, ErrorEnvelope> {
        return request(.search(scope: scope, keyword: keyword,  sort: sort, order: order))
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
            print("\(URL)")
            
            return Service.session.rac_JSONResponse(
                preparedRequest(forURL: URL, method: properties.method, query: properties.query),
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


