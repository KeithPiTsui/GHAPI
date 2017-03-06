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
    case code
    case issues
    case users
    
    public var name: String {
        switch self {
        case .repositories(_):
            return "repositories"
        case .code:
            return "code"
        case .issues:
            return "issues"
        case .users:
            return "users"
        }
    }
}

public protocol SearchQualifier {
    var searchRepresentation: String {get}
}

public enum RepositoriesQualifier: SearchQualifier {
    public enum InArgument: String {
        case name
        case description
        case readme
    }
    public enum NumberComparativeArgument {
        case equal(UInt)
        case lessThan(UInt)
        case biggerThan(UInt)
        case lessAndEqualThan(UInt)
        case biggerAndEqualThan(UInt)
        case between(UInt, UInt)
        
        public var searchRepresentation: String {
            switch self {
            case let .equal(num):
                return "\(num)"
            case let .lessThan(num):
                return "<\(num)"
            case let .biggerThan(num):
                return ">\(num)"
            case let .lessAndEqualThan(num):
                return "<=\(num)"
            case let .biggerAndEqualThan(num):
                return ">=\(num)"
            case let .between(num0, num1):
                let minNum = min(num0, num1)
                let maxNum = max(num0, num1)
                return "\(minNum)..\(maxNum)"
            }
        }
        
    }
    public enum ForkArgument: String {
        case `true`
        case only
    }
    public enum LanguageArgument: String {
        case assembly
    }
    
    case `in`([InArgument])
    case size(NumberComparativeArgument)
    case forks(NumberComparativeArgument)
    case fork(ForkArgument)
    case created(Date)
    case pushed(Date)
    case user([String])
    case repo([String])
    case language([LanguageArgument])
    case stars(NumberComparativeArgument)
    
    public var searchRepresentation: String {
        let rep: String
        switch self {
        case let .in(args):
            rep = "in:" + args.map{$0.rawValue}.joined(separator: ",")
        case let .size(arg):
            rep = "size:" + arg.searchRepresentation
        case let .forks(arg):
            rep = "forks:" + arg.searchRepresentation
        case let .fork(arg):
            rep = "fork:" + arg.rawValue
        case let .created(date):
            rep = "created:" + date.ISO8601DateRepresentation
        case let .pushed(date):
            rep = "pushed:" + date.ISO8601DateRepresentation
        case let .user(args):
            rep = "user:" + args.joined(separator: ",")
        case let .repo(args):
            rep = "repo:" + args.joined(separator: ",")
        case let .language(args):
            rep = "language:" + args.map{$0.rawValue}.joined(separator: ",")
        case let .stars(arg):
            rep = "stars" + arg.searchRepresentation
        }
        return rep
    }
}

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






















































