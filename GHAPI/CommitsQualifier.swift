//
//  CommitsQualifier.swift
//  GHAPI
//
//  Created by Pi on 07/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation

public enum CommitsIs: String {
    case `private`
    case `public`
}

public enum CommitsQualifier: SearchQualifier {
    case author(String)
    case committer(String)
    case author_name(String)
    case committer_name(String)
    case author_email(String)
    case committer_email(String)
    case author_date(ComparativeArgument<Date>)
    case committer_date(ComparativeArgument<Date>)
    case merge(Bool)
    case hash(String)
    case parent(hash:String)
    case tree(hash:String)
    case `is`(CommitsIs)
    case user([String])
    case repo([String])
    case org([String])
    
    public var searchRepresentation: String {
        let rep: String
        switch self {
        case let .author(arg):
            rep = "author:" + arg
        case let .committer(arg):
            rep = "commiter:" + arg
        case let .author_name(arg):
            rep = "author-name:" + arg
        case let .committer_name(arg):
            rep = "committer-name:" + arg
        case let .author_email(arg):
            rep = "author-email:" + arg
        case let .committer_email(arg):
            rep = "committer-email:" + arg
        case let .author_date(arg):
            rep = "author-date:" + arg.searchRepresentation
        case let .committer_date(arg):
            rep = "committer-date:" + arg.searchRepresentation
        case let .merge(arg):
            rep = "merge:\(arg)"
        case let .hash(arg):
            rep = "hash:" + arg
        case let .parent(arg):
            rep = "parent:" + arg
        case let .tree(arg):
            rep = "tree:" + arg
        case let .is(arg):
            rep = "is:" + arg.rawValue
        case let .org(arg):
            rep = "org:" + arg.joined(separator: ",")
        case let .user(args):
            rep = "user:" + args.joined(separator: ",")
        case let .repo(args):
            rep = "repo:" + args.joined(separator: ",")
        }
        return rep
    }
}










