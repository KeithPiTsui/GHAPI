//
//  String-Extension.swift
//  GHAPI
//
//  Created by Pi on 11/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation

infix operator -~: AdditionPrecedence

extension String {
    public var ghUrlPatternRemoved: String {
        return self -~ ("", "\\{.*\\}") -~ ("", "/*$")
    }
    
    public func replaced(by template: String, withRegex pattern: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return self}
        let mutableStr = NSMutableString(string: self)
        regex.replaceMatches(in: mutableStr,
                             options: [],
                             range: NSRange(location: 0, length: mutableStr.length),
                             withTemplate: template)
        
        return mutableStr as String
    }

    public static func -~ (lhs: String, rhs: (template: String, regexPattern: String)) -> String {
        return lhs.replaced(by: rhs.template, withRegex: rhs.regexPattern)
    }
}
