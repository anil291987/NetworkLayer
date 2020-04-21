/*
* NetworkLayer: https://github.com/MobileMatrix/NetworkLayer.git
*
* Copyright (c) 2020 MobileMatrix
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
*/

import Foundation

enum NetworkEnvironment {
  case qa
  case production
  case staging
}

class NetworkManager {
  static let MovieAPIKey = ""
  static let environment: NetworkEnvironment = .production
  var router = Router<MovieAPI>()

  fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
    switch response.statusCode {
    case 200...229:
      return .success
    case 401...500:
      return .failure(NetworkResponse.authenticationError.rawValue)
    case 501...599:
      return .failure(NetworkResponse.badRequest.rawValue)
    case 600:
      return .failure(NetworkResponse.outdated.rawValue)
    default:
      return .failure(NetworkResponse.failed.rawValue)
    }
  }
  func execute(with closure: @escaping () -> Void) { closure() }

}

enum NetworkResponse: String {
  case success
  case authenticationError = "You neet to be authenticated first."
  case badRequest = "Bad Request"
  case outdated = "The url you requested is outdated."
  case failed = "Network request failed."
  case noData = "Response returned with no data to decode."
  case unableToDecode = "We could not decode the response."
}

enum Result<String> {
  case success
  case failure(String)
}

extension NetworkManager {
  func getNewMovies(page: Int, completion: @escaping (_ movie: [Movie]?, _ error: String?) -> Void)
  {
    router.request(.newMovies(page: page)) { (data, response, error) in

      if error != nil {
        completion(nil, "Please check your network connection.")
      }

      if let response = response as? HTTPURLResponse {
        let result = self.handleNetworkResponse(response)
        switch result {
        case .success:
          guard let responseData = data else {
            completion(nil, NetworkResponse.noData.rawValue)
            return
          }
          do {
            debugPrint(response)
            let jsonData = try JSONSerialization.jsonObject(
              with: responseData, options: .mutableContainers)
            debugPrint(jsonData)
            let apiResponse = try JSONDecoder().decode(MovieApiResponse.self, from: responseData)
            completion(apiResponse.movies, nil)
          } catch {
            debugPrint(error)
            completion(nil, NetworkResponse.unableToDecode.rawValue)
          }
        case .failure(let networkFailureError):
          completion(nil, networkFailureError)
        }
      }
    }
  }
}
