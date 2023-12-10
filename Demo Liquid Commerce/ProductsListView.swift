//
//  ProductsListView.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 10/12/2023.
//

import SwiftUI

struct ProductsListView: View {
    @ObservedObject var productsListViewModel: ProductsListViewModel
    
    var body: some View {
        NavigationStack{
            
            ScrollView(.vertical, content: {
                LazyVGrid(columns: [GridItem(.fixed(UIScreen.main.bounds.width / 2), spacing: 20), GridItem(.flexible())], content: {
                    ForEach(productsListViewModel.products)
                    {
                        product in
                        
                        NavigationLink(destination: ProductDetailView(product: product)){
                            ProductCardView(productsListViewModel: productsListViewModel, product: product).frame(width: (UIScreen.main.bounds.width / 2) - 10, height: 256)
                                .onAppear{ Task{ try await productsListViewModel.fetchProducts(currentProduct: product) } }
                                .border(.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }.foregroundColor(.black)
                    }
                })
            })
            .onAppear{ Task{ try await productsListViewModel.fetchProducts(currentProduct: nil) }
            }.navigationTitle("Demo Liquid")
        }
        
    }
}
