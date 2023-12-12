//
//  ProductsListView.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 10/12/2023.
//

import SwiftUI

struct ProductsListView: View 
{
    @ObservedObject var productsListViewModel: ProductsListViewModel
    
    
    var body: some View {
        NavigationStack{
            
            ScrollView(.vertical, content: {
                LazyVGrid(columns: [GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 20), GridItem(.flexible())], content: {
                    ForEach(productsListViewModel.products)
                    {
                        product in
                        
                        NavigationLink(destination: ProductDetailView(product: product)){
                            ProductCardView(product: product)
                                .frame(width: (UIScreen.main.bounds.width / 2 - 42) , height: 300)
                                .onAppear{ Task{ try await productsListViewModel.fetchProducts(currentProduct: product) } }
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.purple, lineWidth: 0.5)
                                )
                        }//.foregroundColor(.black)
                        
                    }
                })
                .padding(16)
            })
            .onAppear{ Task{ try await productsListViewModel.fetchProducts(currentProduct: nil) }
            }.navigationTitle(LocalizedStringKey("app_name"))
//                .toolbarBackground(Color.accentColor, for: .navigationBar)
//                .toolbarBackground(.visible, for: .navigationBar)
                
        }
    }
}

#Preview {
    ProductsListView(productsListViewModel: ProductsListViewModel(client: try! BaseAuthClient(basePath: StringConstants.basePath.rawValue)))
}
