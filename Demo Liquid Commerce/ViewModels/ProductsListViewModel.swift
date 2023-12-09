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
    let itemsPerPage = 10
    var numberOfPages = 0
    @Published var products = [Product]()
    
    func fetchProducts(currentProduct: Product?) async throws
    {
        if let currentProduct, let index = products.firstIndex(of: currentProduct), index == itemsPerPage * numberOfPages - 1
        {
            try await fetchNextProductsPage()
        }
        else if numberOfPages == 0
        {
            try await fetchNextProductsPage()
        }
    }
    
    @MainActor
    private func fetchNextProductsPage() async throws
    {
        numberOfPages += 1
        let newProducts = try await client.fetchProducts(numberOfPages)
        products.append(contentsOf: newProducts)
    }
}
