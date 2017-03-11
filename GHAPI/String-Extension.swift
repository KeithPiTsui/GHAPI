//
//  String-Extension.swift
//  GHAPI
//
//  Created by Pi on 11/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation

extension String {
    public var sanitizedUrlStr: String {
        let ranges = self.ranges(ofMatching: "\\{.*\\}")
        var text = self as NSString
        for range in ranges {
            text = text.replacingCharacters(in: range, with: "") as NSString
        }
        return text as String
    }
    
    public func ranges(ofMatching regex: String) -> [NSRange] {
        do {let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            return results.map {$0.range}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
