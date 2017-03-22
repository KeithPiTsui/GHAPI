import Prelude

/**
 A list of possible requests that can be made for Kickstarter data.
 */
internal enum Route {
  internal enum UploadParam: String {
    case image
    case video
  }

  case user(userName: String)

  case resource(url: URL)

  case search(
    scope: SearchScope,
    keyword: String?,
    sort: SearchSorting?,
    order: SearchSortingOrder?)

  case events(userName: String)

  case receivedEvents(userName: String)

  case repository(username: String, reponame: String)

  case contents(repoURL: URL, branch: String?)

  // swiftlint:disable:next large_tuple
  internal var requestProperties: (
    method: Method,
    path: String,
    query: [String:Any],
    file: (name: UploadParam, url: URL)?,
    headers: [String: String]) {

    switch self {

    case let .user(userName):
      return (.GET, "/users/\(userName)", [:], nil, [:])

    case let .resource(url):
      return (.GET, url.path, [:], nil, [:])

    case let .search(scope, keyword, sort, order):
      let path = "/search/\(scope.name)"
      var query: [String: String] = [:]
      if let keyword = keyword { query = ["q":keyword]}

      var qualifiers: [SearchQualifier]? = nil

      switch scope {
      case .repositories(let repoQualifiers):
        qualifiers = repoQualifiers
      case .users(let userQualifiers):
        qualifiers = userQualifiers
      default:
        break
      }
      if let qualifiers = qualifiers, qualifiers.count > 0 {
        let kw = keyword == nil ? "" : (keyword! + "+")
        query["q"] = kw + qualifiers.map{$0.searchRepresentation}.joined(separator: "+")
      }
      if let sort = sort { query["sort"] = sort.rawValue }
      if let order = order { query["order"] = order.rawValue }
      return (.GET, path, query, nil, [:])

    case let .events(username):
      return (.GET, "/users/\(username)/events", [:], nil, [:])

    case let .receivedEvents(username):
      return (.GET, "/users/\(username)/received_events", [:], nil, [:])

    case let .repository(username, reponame):
      return (.GET, "/repos/\(username)/\(reponame)", [:], nil, [:])

    case let .contents(repoURL, branch):
      let contentURL = repoURL.appendingPathComponent("contents")
      var queries: [String:Any] = [:]
      if let branch = branch {
        queries["ref"] = branch
      }
      return (.GET, contentURL.path, queries, nil, [:])
    }
  }
}








