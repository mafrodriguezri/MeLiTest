//
//  MeLiTestApp.swift
//  MeLiTest
//
//  Created by Manuel on 6/8/22.
//

import SwiftUI

@main
struct MeLiTestApp: App {
    
    let viewModel: ProductsViewModel = ProductsViewModel()
    @StateObject var networkHelper: ConnectionStatusHelper = ConnectionStatusHelper()
    
    var body: some Scene {
        WindowGroup {
            ProductsView(viewModel: viewModel)
                .environmentObject(networkHelper)
        }
    }
}
