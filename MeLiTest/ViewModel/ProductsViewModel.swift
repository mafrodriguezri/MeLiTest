//
//  ProductsViewModel.swift
//  MeLiTest
//
//  Created by Manuel on 6/9/22.
//

import SwiftUI
import Combine

protocol ProductsViewModelObservable: ObservableObject {
    
    var productsData: [ProductData] { get }
    var showScreenLoader: Bool { get }
    var refreshScreen: Bool { get }
    var errorMessage: String { get }
    var showErrorModal: Bool { get set }
    
    /// Interface method to fetch the search results for the given query
    /// - Parameter query: The search query
    func fetchSearchResults(query: String, networkAvailable: Bool)
    /// Interface method for requesting the image for a product
    /// - Parameter imageUrl: The url for the image
    /// - Returns: The image obtained
    func getProductImageFrom(_ imageUrl: String) -> Image?
}

protocol ProductsViewModelInterface: AnyObject {
    
    /// Delegate method to receive the search data from a given query
    /// - Parameter data: The results from the request
    func receiveSearchData(_ data: [ProductData]?)
    /// Delegate method indicating that the downloading images were saved in the device's cache
    func localImagesSaved()
}

final class ProductsViewModel: ProductsViewModelObservable, ProductsViewModelInterface {
    
    @Published var productsData: [ProductData] = []
    @Published var showScreenLoader: Bool = false
    @Published var refreshScreen: Bool = false
    @Published var errorMessage: String = ""
    @Published var showErrorModal: Bool = false
    
    private lazy var apiManager: APIManagerInterface = APIManager(delegate: self)
    
    func fetchSearchResults(query: String, networkAvailable: Bool) {
        if query.isEmpty {
            errorMessage = Constants.emptyQueryMessage
            showErrorModal = true
        } else if !networkAvailable {
            errorMessage = Constants.networkErrorMessage
            showErrorModal = true
        } else {
            showScreenLoader = true
            apiManager.getApiProductSearchFor(query: query)
        }
    }
    
    func receiveSearchData(_ data: [ProductData]?) {
        DispatchQueue.main.async { [weak self] in
            self?.productsData = data ?? []
            self?.showScreenLoader = false
            if self?.productsData == nil || self?.productsData == [] {
                self?.errorMessage = Constants.searchErrorMessage
                self?.showErrorModal = true
            }
        }
    }

    func getProductImageFrom(_ imageUrl: String) -> Image? {
        guard let uiImage: UIImage = apiManager.getImageFromCacheWithKey(imageUrl) else { return nil }
        return Image(uiImage: uiImage)
    }
    
    func localImagesSaved() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshScreen.toggle()
        }
    }
}
