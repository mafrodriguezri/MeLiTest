//
//  APIManager.swift
//  MeLiTest
//
//  Created by Manuel on 6/8/22.
//

import SwiftUI
import Combine

protocol APIManagerInterface: AnyObject {
    
    /// Interface method for requesting the search results for the given query
    /// - Parameter query: The search query
    func getApiProductSearchFor(query: String)
    /// Retrieves an image from the device's cache
    /// - Parameter urlKey: The url for the image
    /// - Returns: The image retrieved
    func getImageFromCacheWithKey(_ urlKey: String) -> UIImage?
}

final class APIManager: APIManagerInterface {
    
    var urlDataTask: URLSessionDataTask?
    let dispatchGroup: DispatchGroup = DispatchGroup()
    weak var delegate: ProductsViewModelInterface?
    
    init(delegate: ProductsViewModelInterface?) {
        self.delegate = delegate
    }
    
    // MARK: - API calls
    func getApiProductSearchFor(query: String) {
        urlDataTask?.cancel()
        getApiProductSearchFor(query: query) { [weak self] productData in
            self?.delegate?.receiveSearchData(productData)
            self?.requestImagesFromData(productData)
        }
    }
    
    /// Requests the search results for the given query
    /// - Parameters:
    ///   - query: The search query
    ///   - completion: Closure receiving the results from the request
    private func getApiProductSearchFor(query: String, completion: @escaping ([ProductData]?) -> Void) {
        
        var parameters: [String: String] = Constants.parameters
        parameters[Constants.queryKey] = query
        
        if var components: URLComponents = URLComponents(string: Constants.baseURL) {
            
            components.queryItems = parameters.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            
            if let url: URL = components.url {
                let request: URLRequest = URLRequest(url: url)
                let session: URLSession = URLSession(configuration: .default)
                urlDataTask = session.dataTask(with: request) { data, response, error in
                    if let error: Error = error {
                        print("Error in search request: \(error.localizedDescription)")
                        completion(nil)
                    } else if let safeData: Data = data,
                              let search: MeLiSearch = self.decodeJSONData(safeData) {
                        completion(search.results)
                    }
                }
                urlDataTask?.resume()
            }
        }
    }
}
// MARK: - Decoding
extension APIManager {
    /// Generic data decoder
    /// - Parameter data: The data to decode
    /// - Returns: The resulting decoded object
    func decodeJSONData<T: Decodable>(_ data: Data) -> T? {
        do {
            let decoder: JSONDecoder = JSONDecoder()
            let decodedData: T = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            print("Error decoding search data")
            return nil
        }
    }
}
// MARK: - Images cache methods
extension APIManager {
    
    func getImageFromCacheWithKey(_ urlKey: String) -> UIImage? {
        return ImageCache.shared.object(forKey: urlKey as NSString)
    }
    
    /// Checks if the images for the search are saved locally. If not, requests the images from the urls
    /// - Parameter data: The requested product data
    private func requestImagesFromData(_ data: [ProductData]?) {
        guard let data: [ProductData] = data, !data.isEmpty else { return }
        
        for product in data {
            guard let urlKey: String = product.thumbnail else { return }
            if ImageCache.shared.object(forKey: urlKey as NSString) == nil {
                getImageFromUrl(urlKey)
                print("Local Image not found with key: \(urlKey)")
            }
        }
    }
    
    /// Downloads an image
    /// - Parameter imageURL: The url for the image
    private func getImageFromUrl(_ imageURL: String) {
        let secureUrl: String = imageURL.replacingOccurrences(of: "http://", with: "https://")
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.dispatchGroup.enter()
            if let url: NSURL = NSURL(string: secureUrl),
               let data: NSData = NSData(contentsOf: url as URL),
               let image: UIImage = UIImage(data: data as Data) {
                self?.saveImageToCacheWithKey(imageURL, image: image)
            } else {
                self?.saveImageToCacheWithKey(imageURL, image: nil)
            }
        }
    }
    
    /// Saves downloaded images to the device's cache
    /// - Parameters:
    ///   - urlKey: The url for the image
    ///   - image: The downloaded image
    private func saveImageToCacheWithKey(_ urlKey: String, image: UIImage?) {
        if let imageToSave: UIImage = image {
            ImageCache.shared.setObject(imageToSave, forKey: urlKey as NSString)
        } else {
            print("Image not found at URL: \(urlKey)")
        }
        dispatchGroup.leave()
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.delegate?.localImagesSaved()
        }
    }
}
