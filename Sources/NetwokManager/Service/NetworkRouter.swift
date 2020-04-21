import Foundation

public typealias NetworkRouterCompletion = (
  _ data: Data?, _ response: URLResponse?, _ error: Error?
) -> Void

protocol NetworkRouter {
  associatedtype EndPoint: EndPointType
  mutating func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
  func cnacel()
}
