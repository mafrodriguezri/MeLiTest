//
//  ContentView.swift
//  MeLiTest
//
//  Created by Manuel on 6/8/22.
//

import SwiftUI

struct ProductsView<ViewModel: ProductsViewModelObservable>: View {
    
    @State private var searchText: String = ""
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var networkHelper: ConnectionStatusHelper
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(viewModel.productsData, id: \.self) { product in
                        NavigationLink(destination: ProductWebView(productUrl: product.permalink ?? "")) {
                            ProductCellView(productImage: viewModel.getProductImageFrom(product.thumbnail ?? ""),
                                            productName: product.title ?? "",
                                            productPrice: product.price ?? .zero)
                        }
                    }
                    .opacity(viewModel.showScreenLoader ? .zero : 1.0)
                }
                .searchable(text: $searchText, prompt: Constants.searchBarPrompt)
                .onSubmit(of: .search, {
                    viewModel.fetchSearchResults(query: searchText,
                                                 networkAvailable: networkHelper.networkAvailable)
                })
                .navigationTitle(Constants.productsViewTitle)
                .navigationBarTitleDisplayMode(.inline)
            }
            if viewModel.showScreenLoader {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)
            }
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.showErrorModal) {
            Button(Constants.modalButtonText, role: .cancel) {}
        }
        .onAppear {
            networkHelper.checkConnectionStatus()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static let viewModel: ProductsViewModel = ProductsViewModel()
    
    static var previews: some View {
        ProductsView(viewModel: viewModel)
            .previewInterfaceOrientation(.portrait)
    }
}
