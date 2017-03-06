import Prelude

/**
 A list of possible requests that can be made for Kickstarter data.
 */
internal enum Route {
    enum UploadParam: String {
        case image
        case video
    }
    
    case user(userName: String)
    case search(scope: SearchScope,
        keyword: String,
        qualifiers: [SearchQualifier]?,
        sort: SearchSorting?,
        order: SearchSortingOrder?
    )
    
    
    // swiftlint:disable:next large_tuple
    internal var requestProperties: (
        method: Method,
        path: String,
        query: [String:Any],
        file: (name: UploadParam, url: URL)?) {
        switch self {
            
        case let .user(userName):
            return (.GET, "/users/\(userName)", [:], nil)
            
        case let .search(scope, keyword, qualifiers, sort, order):
            let path = "/search/\(scope.name)"
            var query = ["q":keyword]
            
            if let qualifiers = qualifiers, qualifiers.count > 0 {
                query["q"] = keyword
                    + "+"
                    + qualifiers.map{$0.searchRepresentation}.joined(separator: "+")
            }
            if let sort = sort { query["sort"] = sort.rawValue }
            if let order = order { query["order"] = order.rawValue }
            return (.GET, path, query, nil)
        }
    }
}
