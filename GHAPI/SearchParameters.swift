//
//  SearchParameters.swift
//  GHAPI
//
//  Created by Pi on 06/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation

public enum SearchScope: EnumCasesIterating {
    case repositories([RepositoriesQualifier])
    case code([CodeQualifier])
    case issues([IssueQualifier])
    case users([UserQualifier])
    case commits([CommitsQualifier])
    
    public var caseName: String {
        var fullName = String(describing: self)
        if let range = fullName.range(of: "(") {
            let location = range.lowerBound
            fullName = fullName.substring(to: location)
        }
        return fullName
    }
    
    public var name: String {
        switch self {
        case .repositories(_):
            return "repositories"
        case .code(_):
            return "code"
        case .issues(_):
            return "issues"
        case .users(_):
            return "users"
        case .commits(_):
            return "commits"
        }
    }
    
    public static let userUnit = SearchScope.users([])
    public static let repositoryUnit = SearchScope.repositories([])
    public static let issueUnit = SearchScope.issues([])
    public static let commitUnit = SearchScope.commits([])
    public static let codeUnit = SearchScope.code([])
    
    public static let allCases = [userUnit, repositoryUnit, issueUnit, commitUnit, codeUnit]
}


extension SearchScope: Equatable {
    public static func == (lhs: SearchScope, rhs: SearchScope) -> Bool {
        switch (lhs, rhs) {
        case (repositories(let args0), repositories(let args1)):
            let args0Rep = args0.map{$0.searchRepresentation}.joined(separator: "+")
            let args1Rep = args1.map{$0.searchRepresentation}.joined(separator: "+")
            return args0Rep == args1Rep
        case (code(let args0), code(let args1)):
            let args0Rep = args0.map{$0.searchRepresentation}.joined(separator: "+")
            let args1Rep = args1.map{$0.searchRepresentation}.joined(separator: "+")
            return args0Rep == args1Rep
        case (issues(let args0), issues(let args1)):
            let args0Rep = args0.map{$0.searchRepresentation}.joined(separator: "+")
            let args1Rep = args1.map{$0.searchRepresentation}.joined(separator: "+")
            return args0Rep == args1Rep
        case (users(let args0), users(let args1)):
            let args0Rep = args0.map{$0.searchRepresentation}.joined(separator: "+")
            let args1Rep = args1.map{$0.searchRepresentation}.joined(separator: "+")
            return args0Rep == args1Rep
        case (commits(let args0), commits(let args1)):
            let args0Rep = args0.map{$0.searchRepresentation}.joined(separator: "+")
            let args1Rep = args1.map{$0.searchRepresentation}.joined(separator: "+")
            return args0Rep == args1Rep
        default:
            return false
        }
    }
}


// MARK: -
// MARK: Qualifiers

public protocol SearchQualifier {
    var searchRepresentation: String {get}
}

extension SearchQualifier {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.searchRepresentation == rhs.searchRepresentation
    }
}

public enum SearchSorting: String {
    case `default`
    case stars
    case forks
    case updated
}

extension SearchSorting: HashableEnumCaseIterating{}

public enum SearchSortingOrder: String {
    case asc
    case desc
}

extension SearchSortingOrder: HashableEnumCaseIterating{}

// MARK: -
// MARK: Arguments

public protocol SearchValueTypeRepresentation: Comparable {
    var representationSVT: String { get }
}

extension UInt: SearchValueTypeRepresentation {
    public var representationSVT: String {
        return self.description
    }
}

extension Date: SearchValueTypeRepresentation {
    public var representationSVT: String {
        return self.ISO8601DateRepresentation
    }
}

public enum LanguageArgument: String {
    case assembly
    case swift
    case csharp
    case jave
    case scalar
    case haskell
    case c
    case javascript
    case html
    case css
}
extension LanguageArgument: HashableEnumCaseIterating{}


extension LanguageArgument: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}

public enum ComparativeArgument<Argument: SearchValueTypeRepresentation> {
    case equal(Argument)
    case lessThan(Argument)
    case biggerThan(Argument)
    case lessAndEqualThan(Argument)
    case biggerAndEqualThan(Argument)
    case between(Argument, Argument)
    case none
    
    public var searchRepresentation: String {
        switch self {
        case let .equal(arg):
            return arg.representationSVT
        case let .lessThan(arg):
            return "<" + arg.representationSVT
        case let .biggerThan(arg):
            return ">" + arg.representationSVT
        case let .lessAndEqualThan(arg):
            return "<=" + arg.representationSVT
        case let .biggerAndEqualThan(arg):
            return ">=" + arg.representationSVT
        case let .between(arg0, arg1):
            let minArg = min(arg0, arg1)
            let maxArg = max(arg0, arg1)
            return "\(minArg)..\(maxArg)"
        case .none:
            return ""
        }
    }
    
    public var upper: Argument? {
        switch self {
        case let .equal(arg):
            return arg
        case let .lessThan(arg):
            return arg
        case .biggerThan(_):
            return nil
        case let .lessAndEqualThan(arg):
            return arg
        case .biggerAndEqualThan(_):
            return nil
        case let .between(_, arg1):
            return arg1
        case .none:
            return nil
        }
    }
    
    public var lower: Argument? {
        switch self {
        case let .equal(arg):
            return arg
        case .lessThan(_):
            return nil
        case let .biggerThan(arg):
            return arg
        case .lessAndEqualThan(_):
            return nil
        case let .biggerAndEqualThan(arg):
            return arg
        case let .between(arg0, _):
            return arg0
        case .none:
            return nil
        }
    }
}





















































