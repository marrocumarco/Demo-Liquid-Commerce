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
                let minimumWidth = UIScreen.main.bounds.width / 2 - 8
                LazyVGrid(columns: [GridItem(.flexible(minimum: minimumWidth, maximum: .infinity), spacing: 0), GridItem(.flexible(minimum: minimumWidth, maximum: .infinity), spacing: 0)], content: {
                    ForEach(productsListViewModel.products)
                    {
                        product in
                        
                        NavigationLink(destination: ProductDetailView(product: product)){
                            ProductCardView(product: product)
                                .frame(height: 300)
                                .onAppear{ Task{ try await productsListViewModel.fetchProducts(currentProduct: product) } }
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(color: .accent.opacity(0.33), radius: 10, x: 2, y: 2)
                                .padding( 16)
                        }
                    }
                })
                
            })
            .onAppear{ Task{ try await productsListViewModel.fetchProducts(currentProduct: nil) }
            }.navigationTitle(LocalizedStringKey("Demo Liquid"))
//                .toolbarBackground(Color.accentColor, for: .navigationBar)
//                .toolbarBackground(.visible, for: .navigationBar)
                
        }
    }
}

#Preview {
    ProductsListView(productsListViewModel: ProductsListViewModel(client: try! BaseAuthClient(), parser: StoreParser()))
}
