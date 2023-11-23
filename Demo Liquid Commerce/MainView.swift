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
//        ProductsListView(productsListViewModel: ProductsListViewModel(client: OAuthClient()))
        TabView {
            ProductsListView(productsListViewModel: ProductsListViewModel(client: OAuthClient()))
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
        
        ScrollView(.horizontal, content: {
            LazyHStack{
                ForEach(productsListViewModel.products)
                {
                    product in
                    CardView(product: product)
                }
            }
        })
        .onAppear{ Task{ try await productsListViewModel.fetchProducts() } }
    }
}

struct CardView: View {
    let product: Product
    var body: some View {
        LazyVStack(content: {
            AsyncImage(url: URL(string: product.images.first?.url ?? ""))
            { image in image.resizable() } placeholder: { Color.red } 
                .frame(width: 128, height: 128)
            Text(product.name)
            Text("Price: \(String(format: "%1$.2f", product.price)) \(Locale.current.currencySymbol!)").strikethrough()
            Text("Sale price: \(String(format: "%1$.2f", product.salePrice)) \(Locale.current.currencySymbol!)")
        }).clipShape(RoundedRectangle(cornerRadius: 25)).padding()
    }
}
