import Argo
import Curry
import Runes

public struct ErrorEnvelope {
  public struct GHError {
    public let resource: String
    public let field: String
    public let code: String
  }
  public let httpCode: Int
  public let message: String
  public let errors: [GHError]?
  public let ghErrCode: GHErrCode?

  public enum GHErrCode: String {
    // Codes defined by the server
    case AccessTokenInvalid = "access_token_invalid"
    case ConfirmFacebookSignup = "confirm_facebook_signup"
    case InvalidXauthLogin = "invalid_xauth_login"
    case TfaFailed = "tfa_failed"
    case TfaRequired = "tfa_required"

    // Catch all code for when server sends code we don't know about yet
    case UnknownCode = "__internal_unknown_code"

    // Codes defined by the client
    case JSONParsingFailed = "json_parsing_failed"
    case ErrorEnvelopeJSONParsingFailed = "error_json_parsing_failed"
    case DecodingJSONFailed = "decoding_json_failed"
    case InvalidPaginationUrl = "invalid_pagination_url"
  }

  /**
   A general error that JSON could not be parsed.
   */
  internal static let couldNotParseJSON = ErrorEnvelope(
    httpCode: 400,
    message: "",
    errors: nil,
    ghErrCode: .JSONParsingFailed
  )

  /**
   A general error that the error envelope JSON could not be parsed.
   */
  internal static let couldNotParseErrorEnvelopeJSON = ErrorEnvelope(
    httpCode: 400,
    message: "",
    errors: nil,
    ghErrCode: .ErrorEnvelopeJSONParsingFailed
  )

  /**
   A general error that some JSON could not be decoded.

   - parameter decodeError: The Argo decoding error.

   - returns: An error envelope that describes why decoding failed.
   */
  internal static func couldNotDecodeJSON(_ decodeError: DecodeError) -> ErrorEnvelope {
    return ErrorEnvelope(
      httpCode: 400,
      message: "Argo decoding error: \(decodeError.description)",
      errors: nil,
      ghErrCode: .DecodingJSONFailed
    )
  }

  /**
   A error that the pagination URL is invalid.

   - parameter decodeError: The Argo decoding error.

   - returns: An error envelope that describes why decoding failed.
   */
  internal static let invalidPaginationUrl = ErrorEnvelope(
    httpCode: 400,
    message: "",
    errors: nil,
    ghErrCode: .InvalidPaginationUrl
  )
}

extension ErrorEnvelope: Error {}

extension ErrorEnvelope: Decodable {
  public static func decode(_ json: JSON) -> Decoded<ErrorEnvelope> {
    let creator = curry(ErrorEnvelope.init)
    let standardErrorEnvelope = creator
      <^> json <| "httpCode"
      <*> json <| "message"
      <*> json <||? "errors"
      <*> json <|? "ghErrCode"
    return standardErrorEnvelope
  }
}

extension ErrorEnvelope.GHError: Decodable {
  public static func decode(_ j: JSON) -> Decoded<ErrorEnvelope.GHError> {
    return curry(ErrorEnvelope.GHError.init)
      <^> j <| "resource"
      <*> j <| "field"
      <*> j <| "code"
  }
}

extension ErrorEnvelope.GHErrCode: Decodable {
  public static func decode(_ j: JSON) -> Decoded<ErrorEnvelope.GHErrCode> {
    switch j {
    case let .string(s):
      return pure(ErrorEnvelope.GHErrCode(rawValue: s) ?? ErrorEnvelope.GHErrCode.UnknownCode)
    default:
      return .typeMismatch(expected: "ErrorEnvelope.GHErrCode", actual: j)
    }
  }
}
