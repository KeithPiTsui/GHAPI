//
//  UserLenses.swift
//  GHAPI
//
//  Created by Pi on 11/04/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Prelude


extension User {
  public enum lens {
    public static let login = Lens<User, String>(
      view: {$0.login},
      set: {User(login: $0, 
                 id: $1.id,
                 avatar: $1.avatar,
                 urls: $1.urls,
                 type: $1.type,
                 siteAdmin: $1.siteAdmin,
                 name: $1.name,
                 company: $1.company,
                 blog: $1.blog,
                 location: $1.location,
                 email: $1.email,
                 hireable: $1.hireable,
                 bio: $1.bio,
                 publicRepos: $1.publicRepos,
                 publicGists: $1.publicGists,
                 followers: $1.followers,
                 following: $1.following,
                 createdDate: $1.createdDate,
                 updatedDate: $1.updatedDate) }
    )

    public static let id = Lens<User, Int>(
      view: {$0.id},
      set: {User(login: $1.login,
                 id: $0,
                 avatar: $1.avatar,
                 urls: $1.urls,
                 type: $1.type,
                 siteAdmin: $1.siteAdmin,
                 name: $1.name,
                 company: $1.company,
                 blog: $1.blog,
                 location: $1.location,
                 email: $1.email,
                 hireable: $1.hireable,
                 bio: $1.bio,
                 publicRepos: $1.publicRepos,
                 publicGists: $1.publicGists,
                 followers: $1.followers,
                 following: $1.following,
                 createdDate: $1.createdDate,
                 updatedDate: $1.updatedDate) }
    )

    public static let avatar = Lens<User, User.Avatar>(
      view: {$0.avatar},
      set: {User(login: $1.login,
                 id: $1.id,
                 avatar: $0,
                 urls: $1.urls,
                 type: $1.type,
                 siteAdmin: $1.siteAdmin,
                 name: $1.name,
                 company: $1.company,
                 blog: $1.blog,
                 location: $1.location,
                 email: $1.email,
                 hireable: $1.hireable,
                 bio: $1.bio,
                 publicRepos: $1.publicRepos,
                 publicGists: $1.publicGists,
                 followers: $1.followers,
                 following: $1.following,
                 createdDate: $1.createdDate,
                 updatedDate: $1.updatedDate) }
    )

    public static let urls = Lens<User, User.URLs>(
      view: {$0.urls},
      set: {User(login: $1.login,
                 id: $1.id,
                 avatar: $1.avatar,
                 urls: $0,
                 type: $1.type,
                 siteAdmin: $1.siteAdmin,
                 name: $1.name,
                 company: $1.company,
                 blog: $1.blog,
                 location: $1.location,
                 email: $1.email,
                 hireable: $1.hireable,
                 bio: $1.bio,
                 publicRepos: $1.publicRepos,
                 publicGists: $1.publicGists,
                 followers: $1.followers,
                 following: $1.following,
                 createdDate: $1.createdDate,
                 updatedDate: $1.updatedDate) }
    )

    public static let type = Lens<User, String>(
      view: {$0.type},
      set: {User(login: $1.login,
                 id: $1.id,
                 avatar: $1.avatar,
                 urls: $1.urls,
                 type: $0,
                 siteAdmin: $1.siteAdmin,
                 name: $1.name,
                 company: $1.company,
                 blog: $1.blog,
                 location: $1.location,
                 email: $1.email,
                 hireable: $1.hireable,
                 bio: $1.bio,
                 publicRepos: $1.publicRepos,
                 publicGists: $1.publicGists,
                 followers: $1.followers,
                 following: $1.following,
                 createdDate: $1.createdDate,
                 updatedDate: $1.updatedDate) }
    )

    public static let siteAdmin = Lens<User, Bool>(
      view: {$0.siteAdmin},
      set: {User(login: $1.login,
                 id: $1.id,
                 avatar: $1.avatar,
                 urls: $1.urls,
                 type: $1.type,
                 siteAdmin: $0,
                 name: $1.name,
                 company: $1.company,
                 blog: $1.blog,
                 location: $1.location,
                 email: $1.email,
                 hireable: $1.hireable,
                 bio: $1.bio,
                 publicRepos: $1.publicRepos,
                 publicGists: $1.publicGists,
                 followers: $1.followers,
                 following: $1.following,
                 createdDate: $1.createdDate,
                 updatedDate: $1.updatedDate) }
    )

    public static let name = Lens<User, String?>(
      view: {$0.name},
      set: {User(login: $1.login,
                 id: $1.id,
                 avatar: $1.avatar,
                 urls: $1.urls,
                 type: $1.type,
                 siteAdmin: $1.siteAdmin,
                 name: $0,
                 company: $1.company,
                 blog: $1.blog,
                 location: $1.location,
                 email: $1.email,
                 hireable: $1.hireable,
                 bio: $1.bio,
                 publicRepos: $1.publicRepos,
                 publicGists: $1.publicGists,
                 followers: $1.followers,
                 following: $1.following,
                 createdDate: $1.createdDate,
                 updatedDate: $1.updatedDate) }
    )

    public static let company = Lens<User, String?>(
      view: {$0.company},
      set: {User(login: $1.login,
                 id: $1.id,
                 avatar: $1.avatar,
                 urls: $1.urls,
                 type: $1.type,
                 siteAdmin: $1.siteAdmin,
                 name: $1.name,
                 company: $0,
                 blog: $1.blog,
                 location: $1.location,
                 email: $1.email,
                 hireable: $1.hireable,
                 bio: $1.bio,
                 publicRepos: $1.publicRepos,
                 publicGists: $1.publicGists,
                 followers: $1.followers,
                 following: $1.following,
                 createdDate: $1.createdDate,
                 updatedDate: $1.updatedDate) }
    )

    public static let blog = Lens<User, String?>(
      view: {$0.blog},
      set: {User(login: $1.login,
                 id: $1.id,
                 avatar: $1.avatar,
                 urls: $1.urls,
                 type: $1.type,
                 siteAdmin: $1.siteAdmin,
                 name: $1.name,
                 company: $1.company,
                 blog: $0,
                 location: $1.location,
                 email: $1.email,
                 hireable: $1.hireable,
                 bio: $1.bio,
                 publicRepos: $1.publicRepos,
                 publicGists: $1.publicGists,
                 followers: $1.followers,
                 following: $1.following,
                 createdDate: $1.createdDate,
                 updatedDate: $1.updatedDate) }
    )

    public static let location = Lens<User, String?>(
      view: {$0.location},
      set: {User(login: $1.login,
                 id: $1.id,
                 avatar: $1.avatar,
                 urls: $1.urls,
                 type: $1.type,
                 siteAdmin: $1.siteAdmin,
                 name: $1.name,
                 company: $1.company,
                 blog: $1.blog,
                 location: $0,
                 email: $1.email,
                 hireable: $1.hireable,
                 bio: $1.bio,
                 publicRepos: $1.publicRepos,
                 publicGists: $1.publicGists,
                 followers: $1.followers,
                 following: $1.following,
                 createdDate: $1.createdDate,
                 updatedDate: $1.updatedDate) }
    )

    public static let email = Lens<User, String?>(
      view: {$0.email},
      set: {User(login: $1.login,
                 id: $1.id,
                 avatar: $1.avatar,
                 urls: $1.urls,
                 type: $1.type,
                 siteAdmin: $1.siteAdmin,
                 name: $1.name,
                 company: $1.company,
                 blog: $1.blog,
                 location: $1.location,
                 email: $0,
                 hireable: $1.hireable,
                 bio: $1.bio,
                 publicRepos: $1.publicRepos,
                 publicGists: $1.publicGists,
                 followers: $1.followers,
                 following: $1.following,
                 createdDate: $1.createdDate,
                 updatedDate: $1.updatedDate) }
    )

    public static let hireable = Lens<User, Bool?>(
      view: {$0.hireable},
      set: {User(login: $1.login,
                 id: $1.id,
                 avatar: $1.avatar,
                 urls: $1.urls,
                 type: $1.type,
                 siteAdmin: $1.siteAdmin,
                 name: $1.name,
                 company: $1.company,
                 blog: $1.blog,
                 location: $1.location,
                 email: $1.email,
                 hireable: $0,
                 bio: $1.bio,
                 publicRepos: $1.publicRepos,
                 publicGists: $1.publicGists,
                 followers: $1.followers,
                 following: $1.following,
                 createdDate: $1.createdDate,
                 updatedDate: $1.updatedDate) }
    )

    public static let bio = Lens<User, String?>(
      view: {$0.bio},
      set: {User(login: $1.login,
                 id: $1.id,
                 avatar: $1.avatar,
                 urls: $1.urls,
                 type: $1.type,
                 siteAdmin: $1.siteAdmin,
                 name: $1.name,
                 company: $1.company,
                 blog: $1.blog,
                 location: $1.location,
                 email: $1.email,
                 hireable: $1.hireable,
                 bio: $0,
                 publicRepos: $1.publicRepos,
                 publicGists: $1.publicGists,
                 followers: $1.followers,
                 following: $1.following,
                 createdDate: $1.createdDate,
                 updatedDate: $1.updatedDate) }
    )

    public static let publicRepos = Lens<User, Int?>(
      view: {$0.publicRepos},
      set: {User(login: $1.login,
                 id: $1.id,
                 avatar: $1.avatar,
                 urls: $1.urls,
                 type: $1.type,
                 siteAdmin: $1.siteAdmin,
                 name: $1.name,
                 company: $1.company,
                 blog: $1.blog,
                 location: $1.location,
                 email: $1.email,
                 hireable: $1.hireable,
                 bio: $1.bio,
                 publicRepos: $0,
                 publicGists: $1.publicGists,
                 followers: $1.followers,
                 following: $1.following,
                 createdDate: $1.createdDate,
                 updatedDate: $1.updatedDate) }
    )

    public static let publicGists = Lens<User, Int?>(
      view: {$0.publicGists},
      set: {User(login: $1.login,
                 id: $1.id,
                 avatar: $1.avatar,
                 urls: $1.urls,
                 type: $1.type,
                 siteAdmin: $1.siteAdmin,
                 name: $1.name,
                 company: $1.company,
                 blog: $1.blog,
                 location: $1.location,
                 email: $1.email,
                 hireable: $1.hireable,
                 bio: $1.bio,
                 publicRepos: $1.publicRepos,
                 publicGists: $0,
                 followers: $1.followers,
                 following: $1.following,
                 createdDate: $1.createdDate,
                 updatedDate: $1.updatedDate) }
    )

    public static let followers = Lens<User, Int?>(
      view: {$0.followers},
      set: {User(login: $1.login,
                 id: $1.id,
                 avatar: $1.avatar,
                 urls: $1.urls,
                 type: $1.type,
                 siteAdmin: $1.siteAdmin,
                 name: $1.name,
                 company: $1.company,
                 blog: $1.blog,
                 location: $1.location,
                 email: $1.email,
                 hireable: $1.hireable,
                 bio: $1.bio,
                 publicRepos: $1.publicRepos,
                 publicGists: $1.publicGists,
                 followers: $0,
                 following: $1.following,
                 createdDate: $1.createdDate,
                 updatedDate: $1.updatedDate) }
    )

    public static let following = Lens<User, Int?>(
      view: {$0.following},
      set: {User(login: $1.login,
                 id: $1.id,
                 avatar: $1.avatar,
                 urls: $1.urls,
                 type: $1.type,
                 siteAdmin: $1.siteAdmin,
                 name: $1.name,
                 company: $1.company,
                 blog: $1.blog,
                 location: $1.location,
                 email: $1.email,
                 hireable: $1.hireable,
                 bio: $1.bio,
                 publicRepos: $1.publicRepos,
                 publicGists: $1.publicGists,
                 followers: $1.followers,
                 following: $0,
                 createdDate: $1.createdDate,
                 updatedDate: $1.updatedDate) }
    )

    public static let createdDate = Lens<User, Date?>(
      view: {$0.createdDate},
      set: {User(login: $1.login,
                 id: $1.id,
                 avatar: $1.avatar,
                 urls: $1.urls,
                 type: $1.type,
                 siteAdmin: $1.siteAdmin,
                 name: $1.name,
                 company: $1.company,
                 blog: $1.blog,
                 location: $1.location,
                 email: $1.email,
                 hireable: $1.hireable,
                 bio: $1.bio,
                 publicRepos: $1.publicRepos,
                 publicGists: $1.publicGists,
                 followers: $1.followers,
                 following: $1.following,
                 createdDate: $0,
                 updatedDate: $1.updatedDate) }
    )

    public static let updatedDate = Lens<User, Date?>(
      view: {$0.updatedDate},
      set: {User(login: $1.login,
                 id: $1.id,
                 avatar: $1.avatar,
                 urls: $1.urls,
                 type: $1.type,
                 siteAdmin: $1.siteAdmin,
                 name: $1.name,
                 company: $1.company,
                 blog: $1.blog,
                 location: $1.location,
                 email: $1.email,
                 hireable: $1.hireable,
                 bio: $1.bio,
                 publicRepos: $1.publicRepos,
                 publicGists: $1.publicGists,
                 followers: $1.followers,
                 following: $1.following,
                 createdDate: $1.createdDate,
                 updatedDate: $0) }
    )
  }
}

extension User.Avatar {
  public enum lens {
    public static let url = Lens<User.Avatar, URL> (
      view: {$0.url},
      set: { User.Avatar(url: $0, id: $1.id)}
    )
    public static let id = Lens<User.Avatar, String> (
      view: {$0.id},
      set: { User.Avatar(url: $1.url, id: $0)}
    )
  }
}



extension User.URLs {
  public enum lens {
    public static let url = Lens<User.URLs, URL> (
      view: {$0.url},
      set: {User.URLs(url: $0,
                      htmlUrl: $1.htmlUrl,
                      followersUrl: $1.followersUrl,
                      followingUrl: $1.followingUrl,
                      gitsUrl: $1.gitsUrl,
                      starredUrl: $1.starredUrl,
                      subscriptionsUrl: $1.subscriptionsUrl,
                      organizationsUrl: $1.organizationsUrl,
                      reposUrl: $1.reposUrl,
                      eventsUrl: $1.eventsUrl,
                      receivedEventsUrl: $1.receivedEventsUrl)}
    )

    public static let htmlUrl = Lens<User.URLs, URL> (
      view: {$0.htmlUrl},
      set: {User.URLs(url: $1.url,
                      htmlUrl: $0,
                      followersUrl: $1.followersUrl,
                      followingUrl: $1.followingUrl,
                      gitsUrl: $1.gitsUrl,
                      starredUrl: $1.starredUrl,
                      subscriptionsUrl: $1.subscriptionsUrl,
                      organizationsUrl: $1.organizationsUrl,
                      reposUrl: $1.reposUrl,
                      eventsUrl: $1.eventsUrl,
                      receivedEventsUrl: $1.receivedEventsUrl)}
    )

    public static let followersUrl = Lens<User.URLs, URL> (
      view: {$0.followersUrl},
      set: {User.URLs(url: $1.url,
                      htmlUrl: $1.htmlUrl,
                      followersUrl: $0,
                      followingUrl: $1.followingUrl,
                      gitsUrl: $1.gitsUrl,
                      starredUrl: $1.starredUrl,
                      subscriptionsUrl: $1.subscriptionsUrl,
                      organizationsUrl: $1.organizationsUrl,
                      reposUrl: $1.reposUrl,
                      eventsUrl: $1.eventsUrl,
                      receivedEventsUrl: $1.receivedEventsUrl)}
    )

    public static let followingUrl = Lens<User.URLs, URL> (
      view: {$0.followingUrl},
      set: {User.URLs(url: $1.url,
                      htmlUrl: $1.htmlUrl,
                      followersUrl: $1.followersUrl,
                      followingUrl: $0,
                      gitsUrl: $1.gitsUrl,
                      starredUrl: $1.starredUrl,
                      subscriptionsUrl: $1.subscriptionsUrl,
                      organizationsUrl: $1.organizationsUrl,
                      reposUrl: $1.reposUrl,
                      eventsUrl: $1.eventsUrl,
                      receivedEventsUrl: $1.receivedEventsUrl)}
    )

    public static let gitsUrl = Lens<User.URLs, URL> (
      view: {$0.gitsUrl},
      set: {User.URLs(url: $1.url,
                      htmlUrl: $1.htmlUrl,
                      followersUrl: $1.followersUrl,
                      followingUrl: $1.followingUrl,
                      gitsUrl: $0,
                      starredUrl: $1.starredUrl,
                      subscriptionsUrl: $1.subscriptionsUrl,
                      organizationsUrl: $1.organizationsUrl,
                      reposUrl: $1.reposUrl,
                      eventsUrl: $1.eventsUrl,
                      receivedEventsUrl: $1.receivedEventsUrl)}
    )

    public static let starredUrl = Lens<User.URLs, URL> (
      view: {$0.starredUrl},
      set: {User.URLs(url: $1.url,
                      htmlUrl: $1.htmlUrl,
                      followersUrl: $1.followersUrl,
                      followingUrl: $1.followingUrl,
                      gitsUrl: $1.gitsUrl,
                      starredUrl: $0,
                      subscriptionsUrl: $1.subscriptionsUrl,
                      organizationsUrl: $1.organizationsUrl,
                      reposUrl: $1.reposUrl,
                      eventsUrl: $1.eventsUrl,
                      receivedEventsUrl: $1.receivedEventsUrl)}
    )

    public static let subscriptionsUrl = Lens<User.URLs, URL> (
      view: {$0.subscriptionsUrl},
      set: {User.URLs(url: $1.url,
                      htmlUrl: $1.htmlUrl,
                      followersUrl: $1.followersUrl,
                      followingUrl: $1.followingUrl,
                      gitsUrl: $1.gitsUrl,
                      starredUrl: $1.starredUrl,
                      subscriptionsUrl: $0,
                      organizationsUrl: $1.organizationsUrl,
                      reposUrl: $1.reposUrl,
                      eventsUrl: $1.eventsUrl,
                      receivedEventsUrl: $1.receivedEventsUrl)}
    )

    public static let organizationsUrl = Lens<User.URLs, URL> (
      view: {$0.organizationsUrl},
      set: {User.URLs(url: $1.url,
                      htmlUrl: $1.htmlUrl,
                      followersUrl: $1.followersUrl,
                      followingUrl: $1.followingUrl,
                      gitsUrl: $1.gitsUrl,
                      starredUrl: $1.starredUrl,
                      subscriptionsUrl: $1.subscriptionsUrl,
                      organizationsUrl: $0,
                      reposUrl: $1.reposUrl,
                      eventsUrl: $1.eventsUrl,
                      receivedEventsUrl: $1.receivedEventsUrl)}
    )

    public static let reposUrl = Lens<User.URLs, URL> (
      view: {$0.reposUrl},
      set: {User.URLs(url: $1.url,
                      htmlUrl: $1.htmlUrl,
                      followersUrl: $1.followersUrl,
                      followingUrl: $1.followingUrl,
                      gitsUrl: $1.gitsUrl,
                      starredUrl: $1.starredUrl,
                      subscriptionsUrl: $1.subscriptionsUrl,
                      organizationsUrl: $1.organizationsUrl,
                      reposUrl: $0,
                      eventsUrl: $1.eventsUrl,
                      receivedEventsUrl: $1.receivedEventsUrl)}
    )

    public static let eventsUrl = Lens<User.URLs, URL> (
      view: {$0.eventsUrl},
      set: {User.URLs(url: $1.url,
                      htmlUrl: $1.htmlUrl,
                      followersUrl: $1.followersUrl,
                      followingUrl: $1.followingUrl,
                      gitsUrl: $1.gitsUrl,
                      starredUrl: $1.starredUrl,
                      subscriptionsUrl: $1.subscriptionsUrl,
                      organizationsUrl: $1.organizationsUrl,
                      reposUrl: $1.reposUrl,
                      eventsUrl: $0,
                      receivedEventsUrl: $1.receivedEventsUrl)}
    )

    public static let receivedEventsUrl = Lens<User.URLs, URL> (
      view: {$0.receivedEventsUrl},
      set: {User.URLs(url: $1.url,
                      htmlUrl: $1.htmlUrl,
                      followersUrl: $1.followersUrl,
                      followingUrl: $1.followingUrl,
                      gitsUrl: $1.gitsUrl,
                      starredUrl: $1.starredUrl,
                      subscriptionsUrl: $1.subscriptionsUrl,
                      organizationsUrl: $1.organizationsUrl,
                      reposUrl: $1.reposUrl,
                      eventsUrl: $1.eventsUrl,
                      receivedEventsUrl: $0)}
    )
  }
}

extension LensType where Whole == User, Part == User.Avatar {
  public var avatarURL: Lens<User, URL> {
    return User.lens.avatar • User.Avatar.lens.url
  }

  public var avatarId: Lens<User, String> {
    return User.lens.avatar • User.Avatar.lens.id
  }
}

extension LensType where Whole == User, Part == User.URLs {
  public var userUrl: Lens<User, URL> {
    return User.lens.urls • User.URLs.lens.url
  }
  public var userHtmlUrl: Lens<User, URL> {
    return User.lens.urls • User.URLs.lens.htmlUrl
  }
  public var userFollowersUrl: Lens<User, URL> {
    return User.lens.urls • User.URLs.lens.followersUrl
  }
  public var userFollowingUrl: Lens<User, URL> {
    return User.lens.urls • User.URLs.lens.followingUrl
  }
  public var userGitsUrl: Lens<User, URL> {
    return User.lens.urls • User.URLs.lens.gitsUrl
  }
  public var userOrganizationsUrl: Lens<User, URL> {
    return User.lens.urls • User.URLs.lens.organizationsUrl
  }
  public var userSubscriptionsUrl: Lens<User, URL> {
    return User.lens.urls • User.URLs.lens.subscriptionsUrl
  }
  public var userReposUrl: Lens<User, URL> {
    return User.lens.urls • User.URLs.lens.reposUrl
  }
  public var userEventsurl: Lens<User, URL> {
    return User.lens.urls • User.URLs.lens.eventsUrl
  }
  public var userReceivedEventsUrl: Lens<User, URL> {
    return User.lens.urls • User.URLs.lens.receivedEventsUrl
  }
}











