//
//  CartViewModel.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 26/04/2024.
//

import Foundation

public class CartViewModel: ObservableObject
{
    @Published var products = [Product]()
    @Published var totalProductsAmount: Double = 0
    @Published var totalTaxesAmount: Double = 0
    @Published var totalAmount: Double = 0
    
    var productsNumber: Int
    {
        products.count
    }
    
    func addProductToCart(_ product: Product)
    {
        products.append(product)
    }
    
    func removeProductFromCart(_ product: Product)
    {
        products.remove(product)
    }
}
