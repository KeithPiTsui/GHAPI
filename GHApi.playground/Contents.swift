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

let service  = Service()
let userSignalProducer = service.user(with: "keith")
userSignalProducer.startWithSignal { (signal, disposable) in

}

userSignalProducer.start()





fileprivate func unwrap<T>(value: Any)
  -> (unwraped:T?, isOriginalType:Bool) {
  let mirror = Mirror(reflecting: value)
  let isOrgType = mirror.subjectType == Optional<T>.self
  if mirror.displayStyle != .optional {
    return (value as? T, isOrgType)
  }
  guard let firstChild = mirror.children.first else {
    return (nil, isOrgType)
  }
  return (firstChild.value as? T, isOrgType)
}

let value: [Int]? = [0]
let value2: [Int]? = nil

let anyValue: Any = value
let anyValue2: Any = value2

let unwrappedResult:([Int]?, Bool)
  = unwrap(value: anyValue)
let unwrappedResult2:([Int]?, Bool)
  = unwrap(value: anyValue2)
let unwrappedResult3:([UInt]?, Bool)
  = unwrap(value: anyValue)
let unwrappedResult4:([NSNumber]?, Bool)
  = unwrap(value: anyValue)
