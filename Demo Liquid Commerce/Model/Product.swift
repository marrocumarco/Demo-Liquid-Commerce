//
//  Product.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 17/10/2023.
//

import Foundation

struct Product: Codable, Identifiable, Equatable
{
    let id: Int
    let name: String
    let description: String
    let shortDescription: String
    let price: Double
    let salePrice: Double
    let onSale: Bool
    let images: [ProductImage]
    let stockStatus: StockStatus
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case description
        case shortDescription
        case price
        case salePrice
        case onSale
        case images
        case stockStatus
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Product.CodingKeys> = try decoder.container(keyedBy: Product.CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: Product.CodingKeys.id)
        self.name = try container.decode(String.self, forKey: Product.CodingKeys.name)
        self.description = try container.decode(String.self, forKey: Product.CodingKeys.description)
        self.shortDescription = try container.decode(String.self, forKey: Product.CodingKeys.shortDescription)
        self.price = Double(try container.decode(String.self, forKey: Product.CodingKeys.price)) ?? 0
        self.salePrice = Double(try container.decode(String.self, forKey: Product.CodingKeys.salePrice)) ?? 0
        self.onSale = try container.decode(Bool.self, forKey: Product.CodingKeys.onSale)
        self.images = try container.decode([ProductImage].self, forKey: Product.CodingKeys.images)
        self.stockStatus =  try container.decode(StockStatus.self, forKey: Product.CodingKeys.stockStatus)
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<Product.CodingKeys> = encoder.container(keyedBy: Product.CodingKeys.self)
        
        try container.encode(self.id, forKey: Product.CodingKeys.id)
        try container.encode(self.name, forKey: Product.CodingKeys.name)
        try container.encode(self.description, forKey: Product.CodingKeys.description)
        try container.encode(self.shortDescription, forKey: Product.CodingKeys.shortDescription)
        try container.encode(self.price.description, forKey: Product.CodingKeys.price)
        try container.encode(self.salePrice.description, forKey: Product.CodingKeys.salePrice)
        try container.encode(self.onSale, forKey: Product.CodingKeys.onSale)
        try container.encode(self.images, forKey: Product.CodingKeys.images)
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
}

enum StockStatus: String, Decodable
{
    case inStock = "instock"
    case outOfStock = "outofstock"
    case oonbackOrder = "onbackorder"
}
