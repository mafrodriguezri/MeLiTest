//
//  ProductWebView.swift
//  MeLiTest
//
//  Created by Manuel on 6/10/22.
//

import SwiftUI

struct ProductWebView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var networkHelper: ConnectionStatusHelper
    @State private var siteFailedToLoad: Bool = false
    @State private var processFinished: Bool = false
    let productUrl: String
    
    var body: some View {
        ZStack {
            if let safeUrl: URL = URL(string: productUrl) {
                WebViewRepresentable(url: safeUrl,
                                     processFinished: $processFinished,
                                     siteFailedToLoad: $siteFailedToLoad)
            }
            if !processFinished {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)
            }
        }
        .alert(Constants.networkErrorMessage, isPresented: $siteFailedToLoad) {
            Button(Constants.modalButtonText, role: .cancel) {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .onAppear {
            siteFailedToLoad = !networkHelper.networkAvailable
            processFinished = false
        }
    }
}

struct ProductWebView_Previews: PreviewProvider {
    static var previews: some View {
        ProductWebView(productUrl: "https://www.mercadolibre.com")
    }
}
