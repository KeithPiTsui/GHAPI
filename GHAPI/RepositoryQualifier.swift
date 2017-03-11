//
//  RepositoryQualifier.swift
//  GHAPI
//
//  Created by Pi on 07/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation

public enum RepositoriesInArgument: String {
    case name
    case description
    case readme
}
extension RepositoriesInArgument: HashableEnumCaseIterating{}
extension RepositoriesInArgument: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}

public enum RepositoriesForkArgument: String {
    case `true`
    case only
}
extension RepositoriesForkArgument: HashableEnumCaseIterating{}
extension RepositoriesForkArgument: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}

public enum RepositoriesQualifier: SearchQualifier {
    case `in`([RepositoriesInArgument])
    case size(ComparativeArgument<UInt>)
    case forks(ComparativeArgument<UInt>)
    case fork(RepositoriesForkArgument)
    case created(ComparativeArgument<Date>)
    case pushed(ComparativeArgument<Date>)
    case user([String])
    case repo([String])
    case language([LanguageArgument])
    case stars(ComparativeArgument<UInt>)
    
    public var searchRepresentation: String {
        let rep: String
        switch self {
        case let .in(args):
            if args.isEmpty {rep = ""} else {
                rep = "in:" + args.map{$0.rawValue}.joined(separator: ",")}
        case let .size(arg):
            rep = "size:" + arg.searchRepresentation
        case let .forks(arg):
            rep = "forks:" + arg.searchRepresentation
        case let .fork(arg):
            rep = "fork:" + arg.rawValue
        case let .created(date):
            rep = "created:" + date.searchRepresentation
        case let .pushed(date):
            rep = "pushed:" + date.searchRepresentation
        case let .user(args):
            let args = args.filter{$0.isEmpty == false}
            if args.isEmpty {rep = ""} else {
                rep = "user:" + args.joined(separator: ",")}
        case let .repo(args):
            if args.isEmpty {rep = ""} else {
                rep = "repo:" + args.joined(separator: ",")}
        case let .language(args):
            if args.isEmpty {rep = ""} else {
                rep = "language:" + args.map{$0.rawValue}.joined(separator: ",")}
        case let .stars(arg):
            rep = "stars:" + arg.searchRepresentation
        }
        return rep
    }
}
