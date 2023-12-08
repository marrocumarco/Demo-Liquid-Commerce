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

struct ProductsListView: View {
    @ObservedObject var productsListViewModel: ProductsListViewModel
    
    var body: some View {
        
        ScrollView(.horizontal, content: {
            LazyHStack{
                ForEach(productsListViewModel.products)
                {
                    product in
                    CardView(productsListViewModel: productsListViewModel, product: product).frame(width: 128, height: 256)
                }
            }
        })
        .onAppear{ Task{ try await productsListViewModel.fetchProducts() } }
    }
}

struct CardView: View {
    let productsListViewModel: ProductsListViewModel
    let product: Product
    @State var imagePath: String?

    var body: some View {
        LazyVStack(content: {
            AsyncImage(url: URL(fileURLWithPath: imagePath ?? "" ))
            { image in image.resizable() } placeholder: { Image("image_placeholder").resizable() }.aspectRatio(contentMode: .fit)
                
            Text(product.name)
            Text("Price: \(String(format: "%1$.2f", product.price)) \(Locale.current.currencySymbol!)")//.strikethrough()
//            Text("Sale price: \(String(format: "%1$.2f", product.salePrice)) \(Locale.current.currencySymbol!)")
        }).clipShape(RoundedRectangle(cornerRadius: 25)).padding()
            .onAppear()
        {
            Task{
                imagePath = try? await CachedAsyncImage(url: URL(string: product.images.first?.url ?? "")!).imagePath
            }
        }
    }
}
