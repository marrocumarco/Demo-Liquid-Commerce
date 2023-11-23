//
//  ProductsListViewModel.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 26/10/2023.
//

import Foundation

class ProductsListViewModel: ObservableObject
{
    internal init(client: StoreClient) 
    {
        self.client = client
    }
    
    let client: StoreClient
    
    @Published var products = [Product]()
    
    func fetchProducts() async throws
    {
        products = try await client.fetchProducts()
    }
}
