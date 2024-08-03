//
//  NetworkService.swift
//  UnsplashPhotos
//
//  Created by Mac on 02/08/24.
//

import Foundation
import Combine

class NetworkService {
    static let shared = NetworkService()
    private init() {}

    func fetchData<T: Decodable>(from url: URL) -> AnyPublisher<T, APIError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { _ in APIError.decodingError }
            .eraseToAnyPublisher()
    }
}

