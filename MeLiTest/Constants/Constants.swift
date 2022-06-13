//
//  Constants.swift
//  MeLiTest
//
//  Created by Manuel on 6/8/22.
//

import SwiftUI

struct Constants {
    static let baseURL: String = "https://api.mercadolibre.com/sites/MLA/search"
    static let parameters : [String : String] = ["limit": "20"]
    static let queryKey: String = "q"
    static let emptyQueryMessage: String = "El campo de búsqueda no puede ser vacío."
    static let searchErrorMessage: String = "Error de búsqueda. Intenta nuevamente."
    static let networkErrorMessage: String = "Conexión de red no disponible."
    static let modalButtonText: String = "Aceptar"
    static let productsViewTitle: String = "Búsqueda de Producto"
    static let searchBarPrompt: String = "Busca un producto"
}

class ImageCache {
    private init() {}
    static let shared: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()
}
