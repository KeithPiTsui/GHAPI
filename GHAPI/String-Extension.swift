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
    
    
    public func numbers() -> [Double] {
        let str = self as NSString
        let matches = NSRegularExpression.numberRegex.matches(in: str as String,
                                                              options: [],
                                                              range: NSRange(location: 0, length: str.length))
                            .map{$0.range}
        return matches
            .map{str.substring(with: $0)}
            .map{$0.replacingOccurrences(of: ",", with: "")}
            .map(Double.init)
            .compact()
    }
}

extension NSRegularExpression {
    public static let numberPatter: String = "(:?^|\\s)(?=.)((?:0|(?:[1-9](?:\\d*|\\d{0,2}(?:,\\d{3})*)))?(?:\\.\\d*[1-9])?)(?!\\S)"

    public static var numberRegex: NSRegularExpression {
        guard let regex = try? NSRegularExpression(pattern: numberPatter) else {
            fatalError("Number Patter not fit")
        }
        return regex
    }
}






















