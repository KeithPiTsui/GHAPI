import Argo
import Curry
import Runes

public enum GHAPIRequestingPhase {
  case routing
  case requestConstructing
  case requesting
  case networking
  case reponseHandling
  case jsonConverting
  case ghAPIModelConverting
  case unknown
}

public enum GHAPIErrorType {
  case noRoute
  case cannotConstructRequest
  case noNetwork
  case networkTimeout
  case networkError
  case jsonParsingFailed
  case ErrorEnvelopeJSONParsingFailed
  case DecodingJSONFailed
  case GHAPIReturnError
  case InvalidPaginationUrl
  case unknown
}


public struct ErrorEnvelope {
  public let requestingPhase: GHAPIRequestingPhase
  public let errorType: GHAPIErrorType
  public let message: String
  public let ghErrorEnvelope: GHErrorEnvelope?
  public let responseError: Error?
  public let responseData: Data?
  public let response: URLResponse?

  /**
   A general error that networkTimeout.
   */
  internal static let networkTimeoutError = ErrorEnvelope(
    requestingPhase: .networking,
    errorType: .networkTimeout,
    message: "network time out",
    ghErrorEnvelope: nil,
    responseError: nil,
    responseData: nil,
    response: nil
  )

  internal static let unknownError = ErrorEnvelope(
    requestingPhase: .unknown,
    errorType: .unknown,
    message: "unknown",
    ghErrorEnvelope: nil,
    responseError: nil,
    responseData: nil,
    response: nil
  )

  internal static let noNetworkError = ErrorEnvelope(
    requestingPhase: .networking,
    errorType: .noNetwork,
    message: "no network",
    ghErrorEnvelope: nil,
    responseError: nil,
    responseData: nil,
    response: nil
  )

  internal static let couldNotParseErrorEnvelopeJSON = ErrorEnvelope(
    requestingPhase: .ghAPIModelConverting,
    errorType: .ErrorEnvelopeJSONParsingFailed,
    message: "couldNotParseErrorEnvelopeJSON",
    ghErrorEnvelope: nil,
    responseError: nil,
    responseData: nil,
    response: nil
  )

  internal static let invalidPaginationUrl = ErrorEnvelope(
    requestingPhase: .routing,
    errorType: .InvalidPaginationUrl,
    message: "Cannot construct pagination url",
    ghErrorEnvelope: nil,
    responseError: nil,
    responseData: nil,
    response: nil
  )

  internal static func couldNotParseJSON(from data: Data) -> ErrorEnvelope {
    return ErrorEnvelope(
      requestingPhase: .ghAPIModelConverting,
      errorType: .DecodingJSONFailed,
      message: "json cannot be parsed from data : \(data.description)",
      ghErrorEnvelope: nil,
      responseError: nil,
      responseData: nil,
      response: nil
    )
  }

//  invalidPaginationUrl

  internal static func couldNotDecodeJSON(_ decodeError: DecodeError) -> ErrorEnvelope {
    return ErrorEnvelope(
      requestingPhase: .ghAPIModelConverting,
      errorType: .DecodingJSONFailed,
      message: "Argo decoding error: \(decodeError.description)",
      ghErrorEnvelope: nil,
      responseError: nil,
      responseData: nil,
      response: nil
    )
  }

}

extension ErrorEnvelope: Error {}
