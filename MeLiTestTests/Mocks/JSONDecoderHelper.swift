//
//  JSONDecoderHelper.swift
//  MeLiTestTests
//
//  Created by Manuel on 6/13/22.
//

import Foundation

final class JSONDecoderHelper {
    
    func decodeJSONData<T: Decodable>(_ jsonName: String) -> T? {
        
        let testBundle = Bundle(for: type(of: self))
        guard let jsonUrl: URL = testBundle.url(forResource: jsonName,
                                                withExtension: "json") else { return nil }
        
        do {
            let data: Data = try Data(contentsOf: jsonUrl)
            let decoder: JSONDecoder = JSONDecoder()
            let decodedData: T = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            return nil
        }
    }
}
