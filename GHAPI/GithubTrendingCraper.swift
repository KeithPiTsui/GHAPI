//
//  GithubTrendingCraper.swift
//  GHAPI
//
//  Created by Pi on 14/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation
import Ji

func testJi() {
    let jiDoc = Ji(htmlURL: URL(string: "https://github.com/trending/swift?since=daily")!)
    let titleNode = jiDoc?.xPath("./body/div/div/div/div/div/ol[@class='repo-list']/li/div/h3/a")?.first
    print("title: \(titleNode?.content)")
}
