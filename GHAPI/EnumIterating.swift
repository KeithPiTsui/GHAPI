//
//  EnumIterator.swift
//  GHAPI
//
//  Created by Pi on 10/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation

public protocol EnumCasesIterating {
    static var allCases: [Self] {get}
}

public protocol HashableEnumCaseIterating: Hashable, EnumCasesIterating {}

extension HashableEnumCaseIterating {
    public static var allCases: [Self] {
        var cases: [Self] = []
        for i in iterateEnum(Self.self) {
            cases.append(i)
        }
        return cases
    }
}


fileprivate func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}

