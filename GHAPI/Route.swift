import Prelude

/**
 A list of possible requests that can be made for Kickstarter data.
 */

/**
 "current_user_url": "https://api.github.com/user",
 "current_user_authorizations_html_url": "https://github.com/settings/connections/applications{/client_id}",
 "authorizations_url": "https://api.github.com/authorizations",
 "code_search_url": "https://api.github.com/search/code?q={query}{&page,per_page,sort,order}",
 "commit_search_url": "https://api.github.com/search/commits?q={query}{&page,per_page,sort,order}",
 "emails_url": "https://api.github.com/user/emails",
 "emojis_url": "https://api.github.com/emojis",
 "events_url": "https://api.github.com/events",
 "feeds_url": "https://api.github.com/feeds",
 "followers_url": "https://api.github.com/user/followers",
 "following_url": "https://api.github.com/user/following{/target}",
 "gists_url": "https://api.github.com/gists{/gist_id}",
 "hub_url": "https://api.github.com/hub",
 "issue_search_url": "https://api.github.com/search/issues?q={query}{&page,per_page,sort,order}",
 "issues_url": "https://api.github.com/issues",
 "keys_url": "https://api.github.com/user/keys",
 "notifications_url": "https://api.github.com/notifications",
 "organization_repositories_url": "https://api.github.com/orgs/{org}/repos{?type,page,per_page,sort}",
 "organization_url": "https://api.github.com/orgs/{org}",
 "public_gists_url": "https://api.github.com/gists/public",
 "rate_limit_url": "https://api.github.com/rate_limit",
 "repository_url": "https://api.github.com/repos/{owner}/{repo}",
 "repository_search_url": "https://api.github.com/search/repositories?q={query}{&page,per_page,sort,order}",
 "current_user_repositories_url": "https://api.github.com/user/repos{?type,page,per_page,sort}",
 "starred_url": "https://api.github.com/user/starred{/owner}{/repo}",
 "starred_gists_url": "https://api.github.com/gists/starred",
 "team_url": "https://api.github.com/teams",
 "user_url": "https://api.github.com/users/{user}",
 "user_organizations_url": "https://api.github.com/user/orgs",
 "user_repositories_url": "https://api.github.com/users/{user}/repos{?type,page,per_page,sort}",
 "user_search_url": "https://api.github.com/search/users?q={query}{&page,per_page,sort,order}"
 */

internal enum Route {
  internal enum UploadParam: String {
    case image
    case video
  }

  /// api.github.com
  case apiRoots

  /// user_url: "/users/{user}",
  case user(userName: String)

  /// Every resource pointed by url with api.github.com as its base
  case resource(url: URL)

  /// repository_search_url: /search/repositories?q={query}{&page,per_page,sort,order}
  ///
  /// issue_search_url: /search/issues?q={query}{&page,per_page,sort,order}
  ///
  /// code_search_url: /search/code?q={query}{&page,per_page,sort,order}
  ///
  /// commit_search_url: /search/commits?q={query}{&page,per_page,sort,order}
  ///
  /// user_search_url: /search/users?q={query}{&page,per_page,sort,order}
  case search(
    scope: SearchScope,
    keyword: String?,
    sort: SearchSorting?,
    order: SearchSortingOrder?)

  /// user.events_url
  case events(user: User)

  /// user.received_events_url
  case receivedEvents(user: User)

  /// repository_url: /repos/{owner}/{repo},
  case repository(username: String, reponame: String)

  /// user.repos
  case repositories(user: User)

  /// repo.contents_url?ref=branch
  case contents(repo: Repository, branch: String?)

  /// issue.comments
  case issueComments(issue: Issue)

  /// PullRequest.comments
  case pullRequestComments(pullRequest: PullRequest)

  /// Repository.branch.commits
  case commits(repo: Repository, branch: BranchLite)

  // swiftlint:disable:next large_tuple
  internal var requestProperties: (
    method: Method,
    path: String,
    query: [String:Any],
    file: (name: UploadParam, url: URL)?,
    headers: [String: String]) {

    switch self {

    case .apiRoots:
      return (.GET, "/", [:], nil, [:])

    case let .user(userName):
      return (.GET, "/users/\(userName)", [:], nil, [:])

    case let .resource(url):
      var query = [String: String]()
      if let queriesStr = url.query {
        let queryStrs = queriesStr.components(separatedBy: "&")
        queryStrs.forEach { (queryStr) in
          let keyValue = queryStr.components(separatedBy: "=")
          if keyValue.count == 2 {
            query[keyValue[0]] = keyValue[1]
          }
        }
      }
      return (.GET, url.path, query, nil, [:])

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

    case let .events(user):
      return (.GET, user.urls.eventsUrl.path, [:], nil, [:])

    case let .receivedEvents(user):
      return (.GET, user.urls.receivedEventsUrl.path, [:], nil, [:])

    case let .repository(username, reponame):
      return (.GET, "/repos/\(username)/\(reponame)", [:], nil, [:])

    case let .repositories(user):
      return (.GET, user.urls.reposUrl.path, [:], nil, [:])

    case let .contents(repo, branch):
      var queries: [String:Any] = [:]
      queries["ref"] = branch
      return (.GET, repo.urls.contents_url.path, queries, nil, [:])

    case let .issueComments(issue):
      return (.GET, issue.urls.comments_url.path, [:], nil, [:])

    case let .pullRequestComments(pullRequest):
      return (.GET, pullRequest.urls.comments_url.path, [:], nil, [:])

    case let .commits(repo, branch):
      return (.GET, repo.urls.commits_url.path, ["ref":branch.name], nil, [:])

    }
  }
}








