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
        NavigationStack{
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
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}

struct ProductsListView: View {
    @ObservedObject var productsListViewModel: ProductsListViewModel
    
    var body: some View {
        
        ScrollView(.vertical, content: {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], content: {
                ForEach(productsListViewModel.products)
                {
                    product in
                    
                    NavigationLink(destination: DetailView(string: product.name)){
                        CardView(productsListViewModel: productsListViewModel, product: product).frame(width: 128, height: 256)
                    }
                }
                .navigationDestination(for: String.self, destination: DetailView.init)
                .navigationTitle("Scheda prodotto")
            })
        })
        .onAppear{ Task{ try await productsListViewModel.fetchProducts() } }
    }
}

struct CardView: View {
    let productsListViewModel: ProductsListViewModel
    let product: Product
    @State var imagePath: String?

    var body: some View {
        GeometryReader{proxy in
            LazyVStack(content: {
                AsyncImage(url: URL(fileURLWithPath: imagePath ?? "" ))
                { image in image.resizable() } placeholder: { Image("image_placeholder").resizable() }.aspectRatio(contentMode: .fit).frame(height: proxy.size.height / 2)
                  
                Text(product.name)
                Text("Price: \(String(format: "%1$.2f", product.price)) \(Locale.current.currencySymbol!)")//.strikethrough()
    //            Text("Sale price: \(String(format: "%1$.2f", product.salePrice)) \(Locale.current.currencySymbol!)")
            }).clipShape(RoundedRectangle(cornerRadius: 10)).padding()
                .onAppear()
            {
                Task{
                    imagePath = try? await CachedAsyncThumbnail(url: URL(string: product.images.first?.url ?? "")!, size: CGSize(width: 100, height: 100), scale: UIScreen.main.scale).imagePath
                }
            }
        }
        
    }
}

struct DetailView: View {
    var string: String
    var body: some View {
        Text(string)
    }
}
