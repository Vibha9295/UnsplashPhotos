//
//  UnsplashPhotosTests.swift
//  UnsplashPhotosTests
//
//  Created by Mac on 02/08/24.
//

import XCTest
@testable import UnsplashPhotos

final class UnsplashPhotosTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
import Foundation
import Combine

class MockUnsplashAPI: UnsplashAPI {
    var mockPhotos: [Photo] = []
    var shouldReturnError = false
    
    override func fetchPhotos(query: String, page: Int = 1, perPage: Int = 50) -> AnyPublisher<[Photo], APIError> {
        if shouldReturnError {
            return Fail(error: APIError.decodingError).eraseToAnyPublisher()
        }
        
        let photosToReturn = mockPhotos
        return Just(photosToReturn)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
}

