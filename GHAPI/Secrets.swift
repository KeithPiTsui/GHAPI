public enum Secrets {
  public enum Api {
    public enum Endpoint {
      public static let github = "api.github.com"
      public static let githubTrending = "https://github.com/trending"
      
      public static let ghAPIURL = URL(string: "https://api.github.com")!
      public static let ghURL = URL(string: "https://github.com")!
      public static let ghTrendingURL = URL(string: "https://github.com/trending")!
    }
  }
}
