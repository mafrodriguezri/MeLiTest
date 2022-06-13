//
//  APIManagerTests.swift
//  MeLiTestTests
//
//  Created by Manuel on 6/13/22.
//

import UIKit
import XCTest
@testable import MeLiTest

class APIManagerTests: XCTestCase {
    
    var sut: APIManagerMock!
    
    override func setUp() {
        super.setUp()
        sut = APIManagerMock()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testGetApiProductValidSearch() {
        // Given
        sut.networkAvailable = true
        // When
        sut.getApiProductSearchFor(query: "validResults")
        // Then
        XCTAssert(!sut.results.isEmpty)
        XCTAssertEqual(sut.results.count, 5)
    }
    
    func testGetApiProductInvalidSearch() {
        // Given
        sut.networkAvailable = true
        // When
        sut.getApiProductSearchFor(query: "invalidResults")
        // Then
        XCTAssert(sut.results.isEmpty)
    }
    
    func testGetApiProductSearchNoNetwork() {
        // Given
        sut.networkAvailable = false
        // When
        sut.getApiProductSearchFor(query: "validResults")
        // Then
        XCTAssert(sut.results.isEmpty)
    }
    
    func testGetSavedImageFromCache() {
        // When
        let savedImage: UIImage? = sut.getImageFromCacheWithKey("savedImageUrl")
        // Then
        XCTAssertNotNil(savedImage)
    }
    
    func testGetNotSavedImageFromCache() {
        // When
        let savedImage: UIImage? = sut.getImageFromCacheWithKey("notSavedImageUrl")
        // Then
        XCTAssertNil(savedImage)
    }
}

