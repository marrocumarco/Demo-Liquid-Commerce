//
//  StoreClient.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 25/10/2023.
//

import Foundation

protocol StoreClient
{
    func fetchProducts() async throws -> [Product]
}
