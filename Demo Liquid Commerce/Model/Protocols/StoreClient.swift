//
//  StoreClient.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 25/10/2023.
//

import Foundation

protocol StoreClient
{
    func executeCall(_ endPoint: URL, httpMethod: String, queryItems: [URLQueryItem], credentials: Credentials) async throws -> Data
}

extension StoreClient
{
    func fetchProducts(_ pageNumber: Int) async throws -> Data
    {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("products")) else { throw StoreClientError.InvalidBasePath }
        return try await executeCall(url, httpMethod: HTTPMethod.GET.rawValue, queryItems: [
            URLQueryItem(name: "page", value: pageNumber.description),
            URLQueryItem(name: "orderby", value: "popularity")], credentials: Credentials(key: Bundle.main.infoDictionary?["API_KEY"] as? String ?? "", secret: Bundle.main.infoDictionary?["API_SECRET"] as? String ?? ""))
    }
    
    func fetchCategories() async throws -> Data
    {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("products/categories")) else { throw StoreClientError.InvalidBasePath }
        return try await executeCall(url, httpMethod: HTTPMethod.GET.rawValue, queryItems: [
            URLQueryItem(name: "display", value: "subcategories")
        ], credentials: Credentials(key: Bundle.main.infoDictionary?["API_KEY"] as? String ?? "", secret: Bundle.main.infoDictionary?["API_SECRET"] as? String ?? ""))
    }
    
    func createNewCustomer(_ customer: Customer, credentials: Credentials) async throws -> Data
    {
        guard let url = URL(string: StringConstants.basePathSite.rawValue.appending("users")) else { throw StoreClientError.InvalidBasePath }
        return try await executeCall(url, httpMethod: HTTPMethod.POST.rawValue, queryItems: [URLQueryItem(name: "username", value: customer.username),
                                                                                             URLQueryItem(name: "email", value: customer.email),
                                                                                             URLQueryItem(name: "password", value: customer.password)], credentials: credentials)
    } 
    
    func login(_ username: String, password: String) async throws -> Data
    {
        guard let url = URL(string: StringConstants.basePathSite.rawValue.appending("users/me")) else { throw StoreClientError.InvalidBasePath }
        return try await executeCall(url, httpMethod: HTTPMethod.GET.rawValue, queryItems: [], credentials: Credentials(key: username, secret: password))
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

enum HTTPMethod: String
{
    case GET
    case POST
    case DELETE
    case PUT
}

enum StoreClientError: Error
{
    case InvalidBasePath
    case UndefinedHTTPStatusCode
    case Redirection(statusCode: Int)
    case ClientError(statusCode: Int)
    case ServerError(statusCode: Int)
}
