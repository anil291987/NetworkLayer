import Foundation

struct Router<EndPoint: EndPointType>: NetworkRouter {
  private var task: URLSessionTask?
  mutating func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
    let session = URLSession.shared
    do {
      let request = try self.buildRequest(for: route)
      NetworkLogger.log(request: request)
      task = session.dataTask(
        with: request,
        completionHandler: { (data, response, error) in
          completion(data, response, error)
        })
    } catch let error {
      completion(nil, nil, error)
    }
  }
  private func buildRequest(for route: EndPoint) throws -> URLRequest {
    var request = URLRequest(
      url: route.baseURL.appendingPathComponent(route.path),
      cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
    request.httpMethod = route.httpMethod.rawValue
    do {
      switch route.task {
      case .request:
        request.setValue(ContentTypeJSON, forHTTPHeaderField: ContentType)
      case .requestParameters(let bodyParameter, let urlParameters):
        try self.configureParameters(
          bodyParameters: bodyParameter, urlParameters: urlParameters, request: &request)
      case .requestParametersAndHeaders(let bodyParameter, let urlParameters, let additionalHeaders):
        self.addAdditionalHeaders(additionalHeaders, request: &request)
        try self.configureParameters(
          bodyParameters: bodyParameter, urlParameters: urlParameters, request: &request)
      }
      return request
    } catch {
      throw error
    }
  }
  fileprivate func configureParameters(
    bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest
  ) throws {
    do {
      if let bodyParameters = bodyParameters {
        try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
      }
      if let urlParameters = urlParameters {
        try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
      }
    } catch {
      throw error
    }
  }
  fileprivate func addAdditionalHeaders(
    _ additionalHeaders: HTTPHeaders?, request: inout URLRequest
  ) {
    guard let headers = additionalHeaders else {
      return
    }
    for (key, value) in headers {
      request.setValue(value, forHTTPHeaderField: key)
    }
  }
  func cnacel() {
    self.task?.cancel()
  }
}
