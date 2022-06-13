//
//  Entities.swift
//  MeLiTest
//
//  Created by Manuel on 6/8/22.
//

import SwiftUI

struct MeLiSearch: Codable {
    var results: [ProductData]?
}

struct ProductData: Codable, Hashable {
    var title: String?
    var price: Float?
    var permalink: String?
    var thumbnail: String?
}
