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
                ProductsListView(productsListViewModel: ProductsListViewModel(client: try! BaseAuthClient(basePath: StringConstants.basePath.rawValue)))
                    .tabItem {
                        Label(LocalizedStringKey("Menu"), systemImage: "wineglass")
                    }
                
                Button("prova2", action: {})
                    .tabItem {
                        Label("Basket", systemImage: "square.and.pencil")
                    }
            }.tint(Color.accentColor)
    }
}

#Preview {
    MainView(viewModel: MainViewViewModel())
}
