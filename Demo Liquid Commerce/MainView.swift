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
                        Label("Menu", systemImage: "wineglass")
                    }
                
                Button("prova2", action: {})
                    .tabItem {
                        Label("Order", systemImage: "square.and.pencil")
                    }
            }
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}

