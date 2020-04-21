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

public enum MovieAPI {
  case recommended(id: Int)
  case popular(page: Int)
  case newMovies(page: Int)
  case video(id: Int)
}

extension MovieAPI: EndPointType {
  var environmentBaseURL: String {
    switch NetworkManager.environment {
    case .production: return "https://api.themoviedb.org/3/movie/"
    case .qa: return "https://qa.themoviedb.org/3/movie/"
    case .staging: return "https://staging.themoviedb.org/3/movie/"
    }
  }
  var baseURL: URL {
    guard let url = URL(string: self.environmentBaseURL) else {
      fatalError("baseURL could not be configured.")
    }
    return url
  }

  var path: String {
    switch self {
    case .recommended(let id):
      return "\(id)/recommendations"
    case .popular:
      return "popular"
    case .newMovies:
      return "now_playing"
    case .video(let id):
      return "\(id)/videos"
    }
  }

  var httpMethod: HTTPMethod {
    return .get
  }

  var task: HTTPTask {
    switch self {
    case .newMovies(let page):
      return .requestParameters(
        bodyParameter: nil, urlParameters: ["page": page, "api_key": NetworkManager.MovieAPIKey])
    default:
      return .request
    }
  }

  var headers: HTTPHeaders? {
    return nil
  }
}
