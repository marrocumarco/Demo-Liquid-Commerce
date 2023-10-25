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
            Button("prova1", action: {})
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

struct ProductsListView: View {
    @ObservedObject var productsListViewModel: ProductsListViewModel
    
    var body: some View {
        ForEach(productsListViewModel.products){
            product in
//            Label(product.name, image: "")
//            Text(product.name)
//            Text(product.description)
//            Text(product.price)
//            Text(product.salePrice)
        }
                
        
        .onAppear{ Task{ try await productsListViewModel.fetchProducts() } }
    }
}
