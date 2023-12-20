//
//  ContentView.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 17/10/2023.
//

import SwiftUI
import SwiftData

struct MainView: View {
    let viewModel: MainViewViewModel

    var body: some View {
            TabView {
                ProductsListView(productsListViewModel: ProductsListViewModel(client: try! OAuthClient(basePath: StringConstants.testBasePath.rawValue)))
                    .tabItem {
                        Label(LocalizedStringKey("Menu"), systemImage: "wineglass")
                    }
                
                Button("prova2", action: {})
                    .tabItem {
                        Label("Basket", systemImage: "square.and.pencil")
                    }
            }
    }
}

#Preview {
    MainView(viewModel: MainViewViewModel())
}
