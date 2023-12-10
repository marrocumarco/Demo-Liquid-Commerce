//
//  ProductImage.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 18/10/2023.
//

import Foundation

struct ProductImage: Codable
{
    internal init(id: Int, url: String, name: String) {
        self.id = id
        self.url = url
        self.name = name
    }
    
    let id: Int
    let url: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url = "src"
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<ProductImage.CodingKeys> = try decoder.container(keyedBy: ProductImage.CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: ProductImage.CodingKeys.id)
        self.url = try container.decode(String.self, forKey: ProductImage.CodingKeys.url)
        self.name = try container.decode(String.self, forKey: ProductImage.CodingKeys.name)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<ProductImage.CodingKeys> = encoder.container(keyedBy: ProductImage.CodingKeys.self)
        try container.encode(self.id, forKey: ProductImage.CodingKeys.id)
        try container.encode(self.url, forKey: ProductImage.CodingKeys.url)
        try container.encode(self.name, forKey: ProductImage.CodingKeys.name)
    }
}
