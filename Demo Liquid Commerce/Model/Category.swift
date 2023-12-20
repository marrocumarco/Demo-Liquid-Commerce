//
//  Category.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 23/11/2023.
//

import Foundation

struct Category: Decodable
{
    let id: Int
    let name: String
    let description: String
    let display: String
    let image: ProductImage?
}
