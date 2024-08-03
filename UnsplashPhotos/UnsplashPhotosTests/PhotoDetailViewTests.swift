//
//  PhotoDetailViewTests.swift
//  UnsplashPhotosTests
//
//  Created by Mac on 03/08/24.
//


import XCTest
import SwiftUI
import Combine
@testable import UnsplashPhotos
final class PhotoDetailViewTests: XCTestCase {
    
    
    private var viewModel: PhotoListViewModel!
    private var mockAPI: MockUnsplashAPI!
    private var cancellables = Set<AnyCancellable>()
    private var photo: Photo!
    @State private var likedPhotos = Set<String>()
    
    override func setUp() {
        super.setUp()
        mockAPI = MockUnsplashAPI()
        viewModel = PhotoListViewModel(api: mockAPI)
        
        photo = Photo(id: "1",
                      urls: Photo.URLs(thumb: "https://example.com/image.jpg"),
                      user: Photo.User(name: "User", portfolioURL: "https://example.com/user"),
                      description: "Sample photo",
                      createdAt: "2024-08-01T00:00:00Z",
                      portfolioURL: nil)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPI = nil
        cancellables.removeAll()
        photo = nil
        super.tearDown()
    }
    
    func testPhotoDetailViewDisplaysPhotoData() {
        let likedPhotosBinding = Binding(
            get: { self.viewModel.likedPhotos },
            set: { self.viewModel.likedPhotos = $0 }
        )
        
        let view = PhotoDetailView(photo: photo, likedPhotos: likedPhotosBinding)
        
        XCTAssertEqual(view.photo.id, photo.id)
        XCTAssertEqual(view.photo.urls.thumb, photo.urls.thumb)
        XCTAssertEqual(view.photo.user.name, photo.user.name)
        XCTAssertEqual(view.photo.description, photo.description)
        XCTAssertEqual(view.photo.createdAt, photo.createdAt)
    }
    
    func testLikeButtonFunctionality() {
        let likedPhotosBinding = Binding(
            get: { self.viewModel.likedPhotos },
            set: { self.viewModel.likedPhotos = $0 }
        )
        
        let view = PhotoDetailView(photo: photo, likedPhotos: likedPhotosBinding)
        
        viewModel.updateLikedPhotos(photo.id)
        
        XCTAssertTrue(viewModel.likedPhotos.contains(photo.id))
        
        viewModel.updateLikedPhotos(photo.id)
        
        XCTAssertFalse(viewModel.likedPhotos.contains(photo.id))
    }
    
    func testExternalLinkOpensInBrowser() {
        let likedPhotosBinding = Binding(
            get: { self.viewModel.likedPhotos },
            set: { self.viewModel.likedPhotos = $0 }
        )
        let view = PhotoDetailView(photo: photo, likedPhotos: likedPhotosBinding)
        
        let expectedURL = URL(string: photo.user.portfolioURL ?? "")
        
        XCTAssertEqual(expectedURL, URL(string: "https://example.com/user"))
    }
}
