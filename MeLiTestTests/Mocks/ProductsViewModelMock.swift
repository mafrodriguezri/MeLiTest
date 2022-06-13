//
//  ProductsViewModelMock.swift
//  MeLiTestTests
//
//  Created by Manuel on 6/13/22.
//

import SwiftUI
@testable import MeLiTest

final class ProductsViewModelMock: ProductsViewModelObservable, ProductsViewModelInterface {
    
    var productsData: [ProductData] = []
    var showScreenLoader: Bool = false
    var refreshScreen: Bool = false
    var errorMessage: String = ""
    var showErrorModal: Bool = false
    
    func fetchSearchResults(query: String, networkAvailable: Bool) {
        if query.isEmpty {
            errorMessage = Constants.emptyQueryMessage
            showErrorModal = true
        } else if !networkAvailable {
            errorMessage = Constants.networkErrorMessage
            showErrorModal = true
        } else {
            showScreenLoader = true
        }
    }
    
    func receiveSearchData(_ data: [ProductData]?) {
        productsData = data ?? []
        showScreenLoader = false
        if productsData == [] {
            errorMessage = Constants.searchErrorMessage
            showErrorModal = true
        }
    }
    
    func getProductImageFrom(_ imageUrl: String) -> Image? {
        if imageUrl == "savedImageUrl" {
            return Image(systemName: "star")
        } else {
            return nil
        }
    }
    
    func localImagesSaved() {
        refreshScreen = true
    }
}
