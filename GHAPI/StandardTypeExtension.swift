//
//  StandardTypeExtension.swift
//  GHAPI
//
//  Created by Pi on 07/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Argo
import Curry
import Runes

extension Date: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Date> {
        switch json {
        case .string(let dateString):
            guard let date = ISO8601DateFormatter().date(from: dateString) else { return .failure(.custom("Date string misformatted"))}
            return pure(date)
        default: return .typeMismatch(expected: "Date", actual: json)
        }
    }
}

extension Date {
    public var ISO8601DateRepresentation: String {
        return ISO8601DateFormatter().string(from: self)
    }
    
    public func string(with pattern: String) -> String {
        let df = DateFormatter()
        df.dateFormat = pattern
        return df.string(from: self)
    }
    
}
