//
//  IssueQualifier.swift
//  GHAPI
//
//  Created by Pi on 07/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation

public enum IssueType: String {
    case issue
    case pr
}

public enum IssueInArgument: String {
    case title
    case body
    case comments
}

public enum IssueState: String{
    case open
    case closed
}

public enum IssueNo: String {
    case label
    case milestone
    case assignee
}

public enum IssueIs: String {
    case open
    case closed
    case merged
}

public enum CommitStatus: String {
    case pending
    case failure
    case success
}

public enum IssueQualifier: SearchQualifier {
    case type(IssueType)
    case `in`([IssueInArgument])
    case author(name: String)
    case assignee(name: String)
    case mentions(name: String)
    case commenter(name: String)
    case involes(name: String)
    case team(name: String)
    case label(labels:[String])
    case no(IssueNo)
    case language([LanguageArgument])
    case `is`(IssueIs)
    case created(ComparativeArgument<Date>)
    case updated(ComparativeArgument<Date>)
    case merged(ComparativeArgument<Date>)
    case closed(ComparativeArgument<Date>)
    case comments(ComparativeArgument<UInt>)
    case status(CommitStatus)
    case head(String)
    case base(branchName: String)
    case user([String])
    case repo([String])
    
    public var searchRepresentation: String {
        let rep: String
        switch self {
        case let .type(arg):
            rep = "type:" + arg.rawValue
        case let .in(args):
            rep = "in:" + args.map{$0.rawValue}.joined(separator: ",")
        case let .author(name):
            rep = "author:" + name
        case let .assignee(name):
            rep = "assignee:" + name
        case let .mentions(name):
            rep = "mentions:" + name
        case let .commenter(name):
            rep = "commenter:" + name
        case let .involes(name):
            rep = "involes:" + name
        case let .team(arg):
            rep = "team:" + arg
        case let .label(labels):
            rep = labels.map{"lable:"+$0}.joined(separator:"+")
        case let .no(arg):
            rep = "no:" + arg.rawValue
        case let .is(arg):
            rep = "is:" + arg.rawValue
        case let .created(date):
            rep = "created:" + date.searchRepresentation
        case let .updated(date):
            rep = "updated:" + date.searchRepresentation
        case let .merged(date):
            rep = "merged:" + date.searchRepresentation
        case let .closed(date):
            rep = "closed:" + date.searchRepresentation
        case let .comments(arg):
            rep = "comments:" + arg.searchRepresentation
        case let .status(arg):
            rep = "status:" + arg.rawValue
        case let .head(arg):
            rep = "head:" + arg
        case let .base(arg):
            rep = "base:" + arg
        case let .user(args):
            rep = "user:" + args.joined(separator: ",")
        case let .repo(args):
            rep = "repo:" + args.joined(separator: ",")
        case let .language(args):
            rep = "language:" + args.map{$0.rawValue}.joined(separator: ",")
        }
        return rep
    }
}

