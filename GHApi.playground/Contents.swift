//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import Argo
import Curry
import Prelude
import Runes
import ReactiveSwift
import Result
import ReactiveExtensions
import GHAPI

//PlaygroundPage.current.needsIndefiniteExecution = true

//let str = "Hello world"

//let service = Service.init(
//    serverConfig: ServerConfig.github,
//    //oauthToken: OauthToken.init(token: "uncomment and put in your token!"),
//    language: "en"
//)
//
//let x = service.testConnectionToGithub()
//
//x.startWithResult { (result) in
//    print(result.value?.id ?? "No value")
//}

//let dateString = "Thu, 22 Oct 2015 07:45:17 +0000"
//let dateFormatter = NSDateFormatter()
//dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss +zzzz"
//dateFormatter.locale = Locale.init(identifier: "en_GB")
//let dateObj = dateFormatter.dateFromString(dateString)
//
//dateFormatter.dateFormat = "MM-dd-yyyy"
//print("Dateobj: \(dateFormatter.stringFromDate(dateObj!))")

//let dateString = "2015-05-12T01:01:22Z"
  let dateString = "2017-02-23T13:48:53Z"
let df = DateFormatter()
/// 2015-05-12T01:01:22Z
df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
let date = df.date(from: dateString)

let isodf = ISO8601DateFormatter()
let d2 = isodf.date(from: dateString)

//guard let date = df.date(from: dateString) else {
////    return Decoded.failure(.custom("Date string misformatted"))
//}


//extension Date: Decodable {
//    public static func decode(_ json: JSON) -> Decoded<Date> {
//        switch json {
//        case .string(let dateString):
//            let df = DateFormatter()
//            /// 2015-05-12T01:01:22Z
//            df.dateFormat = "yyyy-MM-ddThh:mm:ssZ"
//            guard let date = df.date(from: dateString) else {
//                return Decoded.failure(.custom("Date string misformatted"))
//            }
//            return pure(date)
//        default: return .typeMismatch(expected: "Date", actual: json)
//        }
//    }
//}

















