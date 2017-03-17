//
//  GithubTrendingCraper.swift
//  GHAPI
//
//  Created by Pi on 14/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation
import Ji
import Curry


public struct TrendingRepository {
  public let repoOwner: String?
  public let repoName: String?
  public let repoDesc: String?
  public let programmingLanguage: String?
  public let totoalStars: UInt?
  public let forks: UInt?
  public let periodStars: UInt?
}

public struct GithubCraper {
  public enum TrendingPeriod: String {
    case daily
    case weekly
    case monthly
  }
  public typealias ProgrammingLanguage = (displayName: String, ghapiName: String)

  public static let githubTrendingURLStr = Secrets.Api.Endpoint.githubTrending
  public static let githubTrendingURL = URL(string: githubTrendingURLStr)!
  public static let trendingDoc = Ji(htmlURL: githubTrendingURL)

  public static let languageItemClassAttributeIdentifier
    = "select-menu-item-text js-select-button-text js-navigation-open"

  public static let programmingLanguages: [ProgrammingLanguage] = {
    guard let htmlNode = trendingDoc?.rootNode else { return [] }
    let languageNodes = htmlNode.descendantsWithAttributeName(
      "class",
      attributeValue: languageItemClassAttributeIdentifier)
    let languages = languageNodes
      .map{ (node) -> ProgrammingLanguage? in
        guard
          let displayname = node.content,
          let ghapiname = node.parent?.attributes["href"]?.components(separatedBy: "/").last
          else { return nil }
        return (displayname, ghapiname)
      }
      .compact()
    return languages
  }()

  public static func trendingQuery(of period: TrendingPeriod) -> (key:String, value:String) {
    return ("since", period.rawValue)
  }

  public static func trendingQuery(of language: String) -> (key: String, value: String) {
    return ("l", language)
  }

  public static func trendingRepositories(of period: TrendingPeriod, with language: String?) -> [TrendingRepository]? {
    var urlStr = githubTrendingURLStr
    if let lang = language { urlStr += "/\(lang)"}
    let pQuery = trendingQuery(of: period)
    urlStr += "?\(pQuery.key)=\(pQuery.value)"
    guard let url = URL(string: urlStr) else { return nil }
    guard let doc = Ji(htmlURL: url) else { return nil }
    guard let htmlNode = doc.rootNode else { return nil }
    let repoListNodes = htmlNode.descendantsWithAttributeName("class", attributeValue: "repo-list")
    guard let repoListNode = repoListNodes.first else { return nil }
    return repoListNode.children.map(repository)
  }

  private static func repository(of repoNode: JiNode) -> TrendingRepository {

    let fullName = repoNode.xPath("./div/h3/a").first?.attributes["href"]

    let names = fullName.map{
      $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: "/")
      }?.filter{$0.isEmpty == false}

    let ownerName = names?.first
    let repoName = names?.last

    let desc = repoNode.descendantsWithAttributeName("class", attributeValue: "py-1").first?.firstChild?
      .content?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

    let lang = repoNode.descendantsWithAttributeName("itemprop", attributeValue: "programmingLanguage").first?
      .content?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

    let totalStarsStr = repoNode.descendantsWithAttributeName("aria-label", attributeValue: "Stargazers").first?
      .content?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let totalStars = totalStarsStr?.numbers().first.map(UInt.init)

    let forksStr = repoNode.descendantsWithAttributeName("aria-label", attributeValue: "Forks").first?
      .content?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let forks = forksStr?.numbers().first.map(UInt.init)

    let periodStarsStr = repoNode.xPath("./div[@class='f6 text-gray mt-2']/span[@class='float-right']").first?
      .content?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let periodStars = periodStarsStr?.numbers().first.map(UInt.init)

    return curry(TrendingRepository.init)(ownerName)(repoName)(desc)(lang)(totalStars)(forks)(periodStars)
  }
}


