//
//  Product.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 17/10/2023.
//

import Foundation

struct Product: Codable
{
    let id: Int
    let name: String
    let description: String
    let shortDescription: String
    let price: Int
    let salePrice: Int
    let onSale: Bool
    let images: [ProductImage]
}
