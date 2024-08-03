//
//  PhotoListViewModelTests.swift
//  UnsplashPhotosTests
//
//  Created by Mac on 03/08/24.
//

import XCTest
import Combine
@testable import UnsplashPhotos

class PhotoListViewModelTests: XCTestCase {
    private var viewModel: PhotoListViewModel!
    private var mockAPI: MockUnsplashAPI!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockAPI = MockUnsplashAPI()
        viewModel = PhotoListViewModel(api: mockAPI)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPI = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testFetchPhotosSuccess() {
        let expectedPhotos = [
            Photo(id: "1", urls: Photo.URLs(thumb: "url1"), user: Photo.User(name: "User1", portfolioURL: nil), description: "Description1", createdAt: "2024-08-01T00:00:00Z", portfolioURL: nil),
            Photo(id: "2", urls: Photo.URLs(thumb: "url2"), user: Photo.User(name: "User2", portfolioURL: nil), description: "Description2", createdAt: "2024-08-01T00:00:00Z", portfolioURL: nil)
        ]
        mockAPI.mockPhotos = expectedPhotos
        
        let expectation = XCTestExpectation(description: "Fetch photos successful")
        viewModel.fetchPhotos(query: "nature", page: 1)
        
        viewModel.$photos
            .dropFirst()
            .sink { photos in
                XCTAssertEqual(photos.count, expectedPhotos.count)
                XCTAssertEqual(photos, expectedPhotos)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSearchQueryHandling() {
        let expectedPhotos = [
            Photo(id: "3", urls: Photo.URLs(thumb: "url3"), user: Photo.User(name: "User3", portfolioURL: nil), description: "Description3", createdAt: "2024-08-02T00:00:00Z", portfolioURL: nil)
        ]
        mockAPI.mockPhotos = expectedPhotos
        
        let expectation = XCTestExpectation(description: "Search query handling")
        viewModel.searchQuery = "test"
        
        viewModel.$photos
            .dropFirst()
            .sink { photos in
                XCTAssertEqual(photos.count, expectedPhotos.count)
                XCTAssertEqual(photos, expectedPhotos)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
}
