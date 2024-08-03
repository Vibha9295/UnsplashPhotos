//
//  UnsplashPhotosUITests.swift
//  UnsplashPhotosUITests
//
//  Created by Mac on 02/08/24.
//

import XCTest

class UnsplashPhotosUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchPhotos() {
        let app = XCUIApplication()
        
        let searchField = app.textFields["SearchField"]
        XCTAssertTrue(searchField.exists)
        
        searchField.tap()
        searchField.typeText("nature")
        
        let firstPhoto = app.images.element(boundBy: 0)
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: firstPhoto, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(firstPhoto.exists)
    }
    
    func testLikeFunctionality() {
        let app = XCUIApplication()
        app.launch()
        
        let cell = app.cells.element(boundBy: 0)
        cell.tap()
        
        let likeButton = app.buttons["LikeButton"]
        XCTAssertTrue(likeButton.exists, "Like button should be present")
        likeButton.tap()
        
    }
    
    
    
}
