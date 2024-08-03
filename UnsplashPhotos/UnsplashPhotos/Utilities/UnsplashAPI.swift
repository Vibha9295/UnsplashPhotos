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
    private let accessKey = "aN8P1OWBxKBCGZcEpTAC3ynhaUs1gT_JypAbhytfOFg" // Replace with your Unsplash Access Key
    
    private var imageCache = [String: UIImage]()
    
    func fetchPhotos(query: String, page: Int = 1, perPage: Int = 50) -> AnyPublisher<[Photo], APIError> {
        guard !query.isEmpty else {
            return Fail(error: APIError.invalidData).eraseToAnyPublisher()
        }
        
        let urlString = "\(baseURL)?query=\(query)&page=\(page)&per_page=\(perPage)&client_id=\(accessKey)"
        print(urlString)
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .handleEvents(receiveOutput: { data in
                // Print the raw JSON response for debugging
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    print("API Response: \(json)")
                }
            })
            .decode(type: PhotoResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .mapError { _ in APIError.decodingError }
            .eraseToAnyPublisher()
    }
}

