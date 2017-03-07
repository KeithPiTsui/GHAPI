//
//  CodeQualifier.swift
//  GHAPI
//
//  Created by Pi on 07/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation


public enum CodeInArgument: String {
    case file
    case path
}

public enum CodeForkArgument: String {
    case `true`
}

public enum CodeQualifier: SearchQualifier {
    case `in`([CodeInArgument])
    case size(ComparativeArgument<UInt>)
    case fork(CodeForkArgument)
    case user([String])
    case repo([String])
    case language([LanguageArgument])
    case filename([String])
    case path(String)
    case `extension`(String)
    
    public var searchRepresentation: String {
        let rep: String
        switch self {
        case let .in(args):
            rep = "in:" + args.map{$0.rawValue}.joined(separator: ",")
        case let .size(arg):
            rep = "size:" + arg.searchRepresentation
        case let .fork(arg):
            rep = "fork:" + arg.rawValue
        case let .user(args):
            rep = "user:" + args.joined(separator: ",")
        case let .repo(args):
            rep = "repo:" + args.joined(separator: ",")
        case let .language(args):
            rep = "language:" + args.map{$0.rawValue}.joined(separator: ",")
        case let .filename(arg):
            rep = "filename:" + arg.joined(separator: ",")
        case let .path(arg):
            rep = "path:" + arg
        case let .extension(arg):
            rep = "extension:" + arg
        }
        return rep
    }
}
