//
//  APIManagerMock.swift
//  MeLiTestTests
//
//  Created by Manuel on 6/13/22.
//

import UIKit
@testable import MeLiTest

final class APIManagerMock: APIManagerInterface {
    
    var networkAvailable: Bool = true
    var results: [ProductData] = []
    let decoderHelper: JSONDecoderHelper = JSONDecoderHelper()
    
    func getApiProductSearchFor(query: String) {
        var searchResults: [ProductData] = []
        if networkAvailable {
            let validSearch: MeLiSearch? = decoderHelper.decodeJSONData(query)
            searchResults = validSearch?.results ?? []
        }
        results = searchResults
    }
    
    func getImageFromCacheWithKey(_ urlKey: String) -> UIImage? {
        if urlKey == "savedImageUrl" {
            return UIImage()
        } else {
            return nil
        }
    }
}
