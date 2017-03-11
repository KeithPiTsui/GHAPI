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

PlaygroundPage.current.needsIndefiniteExecution = true

let urlString = "https://api.github.com/repos/keith/asc_476/branches"
let myUrl = URL(string: urlString);
let request = NSMutableURLRequest(url:myUrl!);
request.httpMethod = "GET";
let task = URLSession.shared.dataTask(with: request as URLRequest) {
    data, response, error in
    guard let response = response,
        let data = data  else { return }
    let jsonStr = String(data: data, encoding: .utf8)
    let result:[Branch]? = jsonStr.flatMap(decode)
    guard let first = result?.first else { return }
    print(first.name)
    
}
task.resume()



