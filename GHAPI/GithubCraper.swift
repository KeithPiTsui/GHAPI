//
//  GithubTrendingCraper.swift
//  GHAPI
//
//  Created by Pi on 14/03/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation
import Ji
import PaversFRP


public struct TrendingRepository {
  public let repoOwner: String?
  public let repoName: String?
  public let repoDesc: String?
  public let programmingLanguage: String?
  public let totoalStars: UInt?
  public let forks: UInt?
  public let periodStars: UInt?
  public let url: URL?
}

public struct GithubCraper {
  public enum TrendingPeriod: String {
    case daily
    case weekly
    case monthly
  }
  public typealias ProgrammingLanguage = (displayName: String, ghapiName: String)

  public static let githubTrendingURLStr = Secrets.Api.Endpoint.githubTrending
  public static let githubTrendingURL = Secrets.Api.Endpoint.ghTrendingURL
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

//  <li class="col-12 d-block width-full py-4 border-bottom" id="pa-VegaScroll">
//  <div class="d-inline-block col-9 mb-1">
//  <h3>
//  <a href="/AppliKeySolutions/VegaScroll">
//  <span class="text-normal">AppliKeySolutions / </span>VegaScroll
//  </a>    </h3>
//  </div>
//
//  <div class="float-right">
//
//  <div class="js-toggler-container js-social-container starring-container ">
//  <!-- '"` --><!-- </textarea></xmp> --><form accept-charset="UTF-8" action="/AppliKeySolutions/VegaScroll/unstar" class="starred" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="✓"><input name="authenticity_token" type="hidden" value="lfOR8XT54pxgpMqz6cXcaxHmlbH7JtExwocc1dppkF30At3X+w4qmRwc+c+s1omR/bD4Ey9V7EoYq7PB6T/7zw=="></div>
//  <button type="submit" class="btn btn-sm  js-toggler-target" aria-label="Unstar this repository" title="Unstar AppliKeySolutions/VegaScroll" data-ga-click="Repository, click unstar button, action:trending#index; text:Unstar">
//  <svg aria-hidden="true" class="octicon octicon-star" height="16" version="1.1" viewBox="0 0 14 16" width="14"><path fill-rule="evenodd" d="M14 6l-4.9-.64L7 1 4.9 5.36 0 6l3.6 3.26L2.67 14 7 11.67 11.33 14l-.93-4.74z"></path></svg>
//  Unstar
//  </button>
//  </form>
//  <!-- '"` --><!-- </textarea></xmp> --><form accept-charset="UTF-8" action="/AppliKeySolutions/VegaScroll/star" class="unstarred" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="✓"><input name="authenticity_token" type="hidden" value="saGYHISYdY1MZUojeDrHhen2d3YHkYFmWmJQYyD7B+1vsR6BJZrZ9g0VfLS1DXGhXJWlYfBCSX9KUyJQAjvgQw=="></div>
//  <button type="submit" class="btn btn-sm  js-toggler-target" aria-label="Star this repository" title="Star AppliKeySolutions/VegaScroll" data-ga-click="Repository, click star button, action:trending#index; text:Star">
//  <svg aria-hidden="true" class="octicon octicon-star" height="16" version="1.1" viewBox="0 0 14 16" width="14"><path fill-rule="evenodd" d="M14 6l-4.9-.64L7 1 4.9 5.36 0 6l3.6 3.26L2.67 14 7 11.67 11.33 14l-.93-4.74z"></path></svg>
//  Star
//  </button>
//  </form>  </div>
//
//  </div>
//
//  <div class="py-1">
//  <p class="col-9 d-inline-block text-gray m-0 pr-4">
//  VegaScroll is a lightweight animation flowlayout for UICollectionView completely written in Swift 4, compatible with iOS 11 and Xcode 9.
//  </p>
//  </div>
//
//  <div class="f6 text-gray mt-2">
//  <span class="d-inline-block mr-3">
//  <span class="repo-language-color ml-0" style="background-color:#ffac45;"></span>
//  <span itemprop="programmingLanguage">
//  Swift
//  </span>
//  </span>
//
//  <a class="muted-link d-inline-block mr-3" href="/AppliKeySolutions/VegaScroll/stargazers">
//  <svg aria-label="star" class="octicon octicon-star" height="16" role="img" version="1.1" viewBox="0 0 14 16" width="14"><path fill-rule="evenodd" d="M14 6l-4.9-.64L7 1 4.9 5.36 0 6l3.6 3.26L2.67 14 7 11.67 11.33 14l-.93-4.74z"></path></svg>
//  599
//  </a>
//
//  <a class="muted-link d-inline-block mr-3" href="/AppliKeySolutions/VegaScroll/network">
//  <svg aria-label="fork" class="octicon octicon-repo-forked" height="16" role="img" version="1.1" viewBox="0 0 10 16" width="10"><path fill-rule="evenodd" d="M8 1a1.993 1.993 0 0 0-1 3.72V6L5 8 3 6V4.72A1.993 1.993 0 0 0 2 1a1.993 1.993 0 0 0-1 3.72V6.5l3 3v1.78A1.993 1.993 0 0 0 5 15a1.993 1.993 0 0 0 1-3.72V9.5l3-3V4.72A1.993 1.993 0 0 0 8 1zM2 4.2C1.34 4.2.8 3.65.8 3c0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2zm3 10c-.66 0-1.2-.55-1.2-1.2 0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2zm3-10c-.66 0-1.2-.55-1.2-1.2 0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2z"></path></svg>
//  27
//  </a>
//
//
//  <span class="d-inline-block mr-3">
//  Built by
//  <a href="/AppliKeySolutions/VegaScroll/graphs/contributors" class="no-underline">
//  <img alt="@pvclever" class="avatar mb-1" height="20" src="https://avatars1.githubusercontent.com/u/8464480?v=4&amp;s=40" title="pvclever" width="20">
//  <img alt="@AppliKeySolutions" class="avatar mb-1" height="20" src="https://avatars3.githubusercontent.com/u/10288457?v=4&amp;s=40" title="AppliKeySolutions" width="20">
//  </a>
//  </span>
//
//  <span class="d-inline-block float-sm-right">
//  <svg aria-hidden="true" class="octicon octicon-star" height="16" version="1.1" viewBox="0 0 14 16" width="14"><path fill-rule="evenodd" d="M14 6l-4.9-.64L7 1 4.9 5.36 0 6l3.6 3.26L2.67 14 7 11.67 11.33 14l-.93-4.74z"></path></svg>
//  227 stars today
//  </span>
//  </div>
//  </li>


  private static func repository(of repoNode: JiNode) -> TrendingRepository {

    let fullName = repoNode
      .xPath("./div/h3/a")
      .first?
      .attributes["href"]

    let names = fullName.map{
      $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: "/")
      }?.filter{$0.isEmpty == false}

    let url = fullName.flatMap{ URL(string: $0, relativeTo: Secrets.Api.Endpoint.ghURL) }


    let ownerName = names?.first
    let repoName = names?.last

    let desc = repoNode
      .xPath("./div/p")
      .first?
      .content?
      .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)



    let lang = repoNode
      .descendantsWithAttributeName("itemprop", attributeValue: "programmingLanguage")
      .first?
      .content?
      .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

    let totalStarsStr = repoNode
      .descendantsWithAttributeName("aria-label", attributeValue: "star")
      .first?
      .parent?
      .content?
      .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

    let totalStars = totalStarsStr?.numbers().first.map(UInt.init)


    let forksStr = repoNode
      .descendantsWithAttributeName("aria-label", attributeValue: "fork")
      .first?
      .parent?
      .content?
      .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

    let forks = forksStr?.numbers().first.map(UInt.init)


    let periodStarsStr = repoNode
      .xPath("./div[@class='f6 text-gray mt-2']/span[@class='d-inline-block float-sm-right']")
      .first?
      .content?
      .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

    let periodStars = periodStarsStr?.numbers().first.map(UInt.init)


    return curry(TrendingRepository.init)(ownerName)(repoName)(desc)(lang)(totalStars)(forks)(periodStars)(url)
  }
}






















