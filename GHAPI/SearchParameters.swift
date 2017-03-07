//
//  SearchParameters.swift
//  GHAPI
//
//  Created by Pi on 06/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation

public enum SearchScope {
    case repositories([RepositoriesQualifier])
    case code([CodeQualifier])
    case issues(IssueQualifier)
    case users(UserQualifier)
    case commits
    
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
        case .commits:
            return "commits"
        }
    }
}

// MARK: -
// MARK: Qualifiers

public protocol SearchQualifier { var searchRepresentation: String {get} }

public enum SearchSorting: String {
    case `default`
    case stars
    case forks
    case updated
}

public enum SearchSortingOrder: String {
    case asc
    case dsc
}

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

public enum ComparativeArgument<Argument: SearchValueTypeRepresentation> {
    case equal(Argument)
    case lessThan(Argument)
    case biggerThan(Argument)
    case lessAndEqualThan(Argument)
    case biggerAndEqualThan(Argument)
    case between(Argument, Argument)
    
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
        }
    }
}

public enum LanguageArgument: String {
    case assembly
}



















































