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

public enum UserQualifier: SearchQualifier {
    case `in`([UserInArgument])
    case created(ComparativeArgument<Date>)
    case followers(UInt)
    case location(String)
    case repo([String])
    case language([LanguageArgument])
    
    public var searchRepresentation: String {
        let rep: String
        switch self {
        case let .in(args):
            rep = "in:" + args.map{$0.rawValue}.joined(separator: ",")
            
        case let .repo(args):
            rep = "repo:" + args.joined(separator: ",")
        case let .language(args):
            rep = "language:" + args.map{$0.rawValue}.joined(separator: ",")
            
        default: break
        }
        return ""
    }
}
