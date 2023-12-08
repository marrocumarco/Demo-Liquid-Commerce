//
//  StoreClient.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 25/10/2023.
//

import Foundation

protocol StoreClient
{
    func executeCall<T: Decodable>(_ pathComponent: String) async throws -> [T]
    func fetchProducts() async throws -> [Product]
    func fetchCategories() async throws -> [Category]
}

extension StoreClient
{
    func fetchProducts() async throws -> [Product]
    {
        return try await executeCall("products")
    }
    
    func fetchCategories() async throws -> [Category] 
    {
        return try await executeCall("products/categories")
    }
}

enum StoreClientError: Error
{
    case InvalidBasePath
    case UndefinedHTTPStatusCode
    case Redirection(statusCode: Int)
    case ClientError(statusCode: Int)
    case ServerError(statusCode: Int)
}
