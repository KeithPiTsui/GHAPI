//
//  UserQualifier.swift
//  GHAPI
//
//  Created by Pi on 07/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation

public enum UserInArgument: String {
    case name
    case description
    case readme
}

public enum UserType: String {
    case user
    case org
}


public enum UserQualifier: SearchQualifier {
    case type(UserType)
    case `in`([UserInArgument])
    case repos(ComparativeArgument<UInt>)
    case location(String)
    case language([LanguageArgument])
    case created(ComparativeArgument<Date>)
    case followers(ComparativeArgument<UInt>)
    
    public var searchRepresentation: String {
        let rep: String
        switch self {
        case let .type(arg):
            rep = "type:" + arg.rawValue
        case let .in(args):
            rep = "in:" + args.map{$0.rawValue}.joined(separator: ",")
        case let .repos(arg):
            rep = "repos:" + arg.searchRepresentation
        case let .location(arg):
            rep = "location:" + arg
        case let .language(args):
            rep = "language:" + args.map{$0.rawValue}.joined(separator: ",")
        case let .created(arg):
            rep = "created:" + arg.searchRepresentation
        case let .followers(arg):
            rep = "followers:" + arg.searchRepresentation
        }
        return rep
    }
}
