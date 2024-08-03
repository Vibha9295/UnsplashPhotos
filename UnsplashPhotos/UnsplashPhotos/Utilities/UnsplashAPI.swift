//
//  UnsplashAPI.swift
//  UnsplashPhotos
//
//  Created by Mac on 02/08/24.
//

import Foundation
import Combine
import UIKit

class UnsplashAPI {
    private let baseURL = "https://api.unsplash.com/search/photos"
    private let accessKey = "aN8P1OWBxKBCGZcEpTAC3ynhaUs1gT_JypAbhytfOFg" 
    
    private var imageCache = [String: UIImage]()
    
    func fetchPhotos(query: String, page: Int = 1, perPage: Int = 50) -> AnyPublisher<[Photo], APIError> {
        let urlString = "https://api.unsplash.com/search/photos?query=\(query)&page=\(page)&per_page=\(perPage)&client_id=\(accessKey)"
        print(urlString)
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PhotoResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .mapError { error in
                print("API Call Error: \(error.localizedDescription)")
                return APIError.decodingError
            }
            .eraseToAnyPublisher()
    }

}

