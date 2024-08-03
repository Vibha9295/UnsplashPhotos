//
//  APIError.swift
//  UnsplashPhotos
//
//  Created by Mac on 02/08/24.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case invalidData
    case decodingError
}

struct ErrorMessage: Identifiable {
    let id = UUID()
    let message: String
}
