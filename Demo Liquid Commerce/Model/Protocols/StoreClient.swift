//
//  StoreClient.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 25/10/2023.
//

import Foundation

protocol StoreClient
{
    func executeCall<T: Decodable>(_ endPoint: String, queryItems: [URLQueryItem]) async throws -> [T]
}

extension StoreClient
{
    func fetchProducts(_ pageNumber: Int) async throws -> [Product]
    {
        return try await executeCall("products", queryItems: [
            URLQueryItem(name: "page", value: pageNumber.description),
            URLQueryItem(name: "orderby", value: "popularity")])
    }
    
    func fetchCategories() async throws -> [Category] 
    {
        return try await executeCall("products/categories", queryItems: [
            URLQueryItem(name: "display", value: "subcategories")
        ])
    }
    
    func checkHTTPStatus(_ status: HTTPStatusCode) throws {
        switch status.responseType {
        case .informational, .success:
            break
        case .redirection:
            throw StoreClientError.Redirection(statusCode: status.rawValue)
        case .clientError:
            throw StoreClientError.ClientError(statusCode: status.rawValue)
        case .serverError:
            throw StoreClientError.ServerError(statusCode: status.rawValue)
        case .undefined:
            throw StoreClientError.Redirection(statusCode: status.rawValue)
        }
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
