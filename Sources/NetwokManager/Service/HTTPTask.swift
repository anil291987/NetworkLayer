import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
  case request
  case requestParameters(bodyParameter: Parameters?, urlParameters: Parameters?)
  case requestParametersAndHeaders(
    bodyParameter: Parameters?, urlParameters: Parameters?, additionalHeaders: HTTPHeaders?)
}
