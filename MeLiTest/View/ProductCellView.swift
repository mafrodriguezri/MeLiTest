//
//  ProductCellView.swift
//  MeLiTest
//
//  Created by Manuel on 6/10/22.
//

import SwiftUI

struct ProductCellView: View {
    
    let productImage: Image?
    let productName: String
    let productPrice: Float
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(.yellow)
                .frame(width: 50.0, height: 50.0)
                .overlay {
                    if let image: Image = productImage {
                        image
                            .resizable()
                            .frame(width: 50.0, height: 50.0)
                    }
                }
            VStack {
                HStack {
                    Text(productName)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text(formatPrice(price: productPrice))
                }
                .padding(.top, 0.1)
            }
            .padding(.leading, 10.0)
        }
    }
    
    /// Receives a Float value and formats it to a currency String
    /// - Parameter price: The Float to format
    /// - Returns: The formatted String
    private func formatPrice(price: Float) -> String {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.groupingSeparator = ","
        return formatter.string(from: price as NSNumber) ?? "$0"
    }
}

struct ProductCellView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCellView(productImage: nil, productName: "Producto", productPrice: 100000)
    }
}
