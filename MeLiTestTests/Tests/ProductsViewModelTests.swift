//
//  ProductsViewModelTests.swift
//  MeLiTestTests
//
//  Created by Manuel on 6/13/22.
//

import SwiftUI
import XCTest
@testable import MeLiTest

class ProductsViewModelTests: XCTestCase {
    
    var sut: ProductsViewModelMock!
    var decoderHelper: JSONDecoderHelper!

    override func setUp() {
        super.setUp()
        sut = ProductsViewModelMock()
        decoderHelper = JSONDecoderHelper()
    }

    override func tearDown() {
        decoderHelper = nil
        sut = nil
        super.tearDown()
    }
    
    func testFetchSearchResultsEmptyQuery() {
        // When
        sut.fetchSearchResults(query: "", networkAvailable: true)
        // Then
        XCTAssertEqual(sut.errorMessage, "El campo de búsqueda no puede ser vacío.")
        XCTAssert(sut.showErrorModal)
    }
    
    func testFetchSearchResultsNotNetwork() {
        // When
        sut.fetchSearchResults(query: "query", networkAvailable: false)
        // Then
        XCTAssertEqual(sut.errorMessage, "Conexión de red no disponible.")
        XCTAssert(sut.showErrorModal)
    }
    
    func testFetchSearchResultsValidQuery() {
        // When
        sut.fetchSearchResults(query: "query", networkAvailable: true)
        // Then
        XCTAssertEqual(sut.errorMessage, "")
        XCTAssert(sut.showScreenLoader)
    }
    
    func testReceiveValidSearchData() {
        // Given
        let validResults: MeLiSearch? = decoderHelper.decodeJSONData("validResults")
        sut.fetchSearchResults(query: "query", networkAvailable: true)
        // When
        sut.receiveSearchData(validResults?.results ?? [])
        // Then
        XCTAssert(!sut.showScreenLoader)
        XCTAssert(!sut.productsData.isEmpty)
        XCTAssertEqual(sut.productsData.count, 5)
        XCTAssertEqual(sut.errorMessage, "")
    }
    
    func testReceiveInvalidSearchData() {
        // Given
        let validResults: MeLiSearch? = decoderHelper.decodeJSONData("invalidResults")
        sut.fetchSearchResults(query: "query", networkAvailable: true)
        // When
        sut.receiveSearchData(validResults?.results ?? [])
        // Then
        XCTAssert(!sut.showScreenLoader)
        XCTAssert(sut.productsData.isEmpty)
        XCTAssert(sut.showErrorModal)
        XCTAssertEqual(sut.errorMessage, "Error de búsqueda. Intenta nuevamente.")
    }
    
    func testGetProductImageFromValidUrl() {
        // When
        let image: Image? = sut.getProductImageFrom("savedImageUrl")
        // Then
        XCTAssertNotNil(image)
    }
    
    func testGetProductImageFromInvalidUrl() {
        // When
        let image: Image? = sut.getProductImageFrom("notSavedImageUrl")
        // Then
        XCTAssertNil(image)
    }
    
    func testLocalImagesSaved() {
        // When
        sut.localImagesSaved()
        // Then
        XCTAssert(sut.refreshScreen)
    }
}
