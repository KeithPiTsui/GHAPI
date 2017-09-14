//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

enum A {
  case hello
  case hi
}

let a = A.hello
let s = "\(a)"

let f: CGFloat = 0.23

let fs: String = String(format: "%-0.1f", f)

var x: UIView? =  UIView()
let y = x

let b = x === y

//import Argo
//import Curry
//import Prelude
//import Prelude_UIKit
//import Runes
//import ReactiveSwift
//import Result
//import ReactiveExtensions
//import GHAPI
//
//
//PlaygroundPage.current.needsIndefiniteExecution = true
//
//let view = UIView()
//view |> UIView.lens.backgroundColor .~ UIColor.red
//PlaygroundPage.current.liveView = view
//

//
//PlaygroundPage.current.needsIndefiniteExecution = true
//let cq = DispatchQueue(label: "concurrent.queue", attributes: .concurrent)
//let cq2 = DispatchQueue(label: "concurent.queue2", attributes: .concurrent)
//let sq = DispatchQueue(label: "serial.queue")
//
//func codeFragment() {
//  print("code Fragment begin")
//  print("Task Thread:\(Thread.current.description)")
//  let imgURL = URL(string: "http://stackoverflow.com/questions/24058336/how-do-i-run-asynchronous-callbacks-in-playground")!
//  let _ = try! Data(contentsOf: imgURL)
//  print("code Fragment completed")
//}
//
//func serialQueueSync() { sq.sync { codeFragment() } }
//func serialQueueAsync() { sq.async { codeFragment() } }
//func concurrentQueueSync() { cq2.sync { codeFragment() } }
//func concurrentQueueAsync() { cq2.async { codeFragment() } }
//
//func tasksExecution() {
//  (1...5).forEach { (_) in
//    /// Using an concurrent queue to simulate concurent task executions.
//    cq.async {
//      print("Caller Thread:\(Thread.current.description)")
//      /// Serial Queue Async, tasks run serially, because only one thread that can be used by serial queue, the underlying thread of serial queue.
//      //serialQueueAsync()
//      /// Serial Queue Sync, tasks run serially, because only one thread that can be used by serial queue,one by one of the callers' threads.
//      //serialQueueSync()
//      /// Concurrent Queue Async, tasks run concurrently, because tasks run on different underlying threads
//      //concurrentQueueAsync()
//      /// Concurrent Queue Sync, tasks run concurrently, because tasks run on different callers' thread
//      //concurrentQueueSync()
//    }
//  }
//}
//tasksExecution()
























