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
extension UserInArgument: HashableEnumCaseIterating{}

extension UserInArgument: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}


public enum UserType: String {
    case user
    case org
}
extension UserType: HashableEnumCaseIterating{}


extension UserType: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}



public enum UserQualifier: SearchQualifier, EnumCasesIterating {
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
            if args.isEmpty {rep = ""} else {
                rep = "in:" + args.map{$0.rawValue}.joined(separator: ",")}
        case let .repos(arg):
            rep = "repos:" + arg.searchRepresentation
        case let .location(arg):
            rep = "location:" + arg
        case let .language(args):
            if args.isEmpty {rep = ""} else {
                rep = "language:" + args.map{$0.rawValue}.joined(separator: ",")}
        case let .created(arg):
            rep = "created:" + arg.searchRepresentation
        case let .followers(arg):
            rep = "followers:" + arg.searchRepresentation
        }
        return rep
    }
    
    public static let typeUnit = UserQualifier.type(UserType.user)
    public static let inUnit = UserQualifier.in([])
    public static let repoUnit = UserQualifier.repos(.none)
    public static let locationUnit = UserQualifier.location("")
    public static let languageUnit = UserQualifier.language([])
    public static let createdUnit = UserQualifier.created(.none)
    public static let followerUnit = UserQualifier.followers(.none)
    
    public static var allCases: [UserQualifier] = [typeUnit, inUnit, repoUnit, locationUnit, languageUnit, createdUnit, followerUnit]
}

extension UserQualifier: Equatable{}
















