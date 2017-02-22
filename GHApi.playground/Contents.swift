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

let service = Service.init(
    serverConfig: ServerConfig.github,
    //oauthToken: OauthToken.init(token: "uncomment and put in your token!"),
    language: "en"
)

let x = service.testConnectionToGithub()

