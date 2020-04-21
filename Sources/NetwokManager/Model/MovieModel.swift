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

struct MovieApiResponse {
  let page: Int
  let numberOfResults: Int
  let numberOfPages: Int
  let movies: [Movie]
}

extension MovieApiResponse: Decodable {

  private enum MovieApiResponseCodingKeys: String, CodingKey {
    case page
    case numberOfResults = "total_results"
    case numberOfPages = "total_pages"
    case movies = "results"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MovieApiResponseCodingKeys.self)

    page = try container.decode(Int.self, forKey: .page)
    numberOfResults = try container.decode(Int.self, forKey: .numberOfResults)
    numberOfPages = try container.decode(Int.self, forKey: .numberOfPages)
    movies = try container.decode([Movie].self, forKey: .movies)

  }
}

struct Movie {
  let id: Int
  let posterPath: String
  let backdrop: String
  let title: String
  let releaseDate: String
  let rating: Double
  let overview: String
}

extension Movie: Decodable {

  enum MovieCodingKeys: String, CodingKey {
    case id
    case posterPath = "poster_path"
    case backdrop = "backdrop_path"
    case title
    case releaseDate = "release_date"
    case rating = "vote_average"
    case overview
  }

  init(from decoder: Decoder) throws {
    let movieContainer = try decoder.container(keyedBy: MovieCodingKeys.self)

    id = try movieContainer.decode(Int.self, forKey: .id)
    posterPath = try movieContainer.decode(String.self, forKey: .posterPath)
    backdrop = try movieContainer.decode(String.self, forKey: .backdrop)
    title = try movieContainer.decode(String.self, forKey: .title)
    releaseDate = try movieContainer.decode(String.self, forKey: .releaseDate)
    rating = try movieContainer.decode(Double.self, forKey: .rating)
    overview = try movieContainer.decode(String.self, forKey: .overview)
  }
}
