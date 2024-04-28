//
//  LineItem.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 22/04/2024.
//

import Foundation

struct LineItem: Codable, Equatable {
    let productId: Int
    let quantity: Int
}
