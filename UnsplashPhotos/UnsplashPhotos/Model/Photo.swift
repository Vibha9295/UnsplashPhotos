//
//  Photo.swift
//  UnsplashPhotos
//
//  Created by Mac on 02/08/24.
//

import Foundation

struct Photo: Decodable, Identifiable, Equatable {
    let id: String
    let urls: URLs
    let user: User
    let description: String?
    let createdAt: String?
    let portfolioURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case urls
        case user
        case description
        case createdAt = "created_at"
        case portfolioURL = "portfolio_url"
    }
    
    struct URLs: Decodable {
        let thumb: String
    }
    
    struct User: Decodable {
        let name: String
        let portfolioURL: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case portfolioURL = "portfolio_url"
        }
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}

struct PhotoResponse: Decodable {
    let results: [Photo]
}
