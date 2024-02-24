//
//  StoreClient.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 25/10/2023.
//

import Foundation

protocol StoreClient
{
    func executeCall<T: Decodable>(_ endPoint: URL, httpMethod: String, queryItems: [URLQueryItem], credentials: Credentials) async throws -> T
}

extension StoreClient
{
    func fetchProducts(_ pageNumber: Int) async throws -> [Product]
    {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("products")) else { throw StoreClientError.InvalidBasePath }
        return try await executeCall(url, httpMethod: HTTPMethod.GET.rawValue, queryItems: [
            URLQueryItem(name: "page", value: pageNumber.description),
            URLQueryItem(name: "orderby", value: "popularity")], credentials: Credentials(key: Bundle.main.infoDictionary?["API_KEY"] as? String ?? "", secret: Bundle.main.infoDictionary?["API_SECRET"] as? String ?? ""))
    }
    
    func fetchCategories() async throws -> [Category] 
    {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("products/categories")) else { throw StoreClientError.InvalidBasePath }
        return try await executeCall(url, httpMethod: HTTPMethod.GET.rawValue, queryItems: [
            URLQueryItem(name: "display", value: "subcategories")
        ], credentials: Credentials(key: Bundle.main.infoDictionary?["API_KEY"] as? String ?? "", secret: Bundle.main.infoDictionary?["API_SECRET"] as? String ?? ""))
    }
    
//    func createNewCustomer(_ customer: Customer) async throws -> Bool
//    {
//        guard let url = URL(string: StringConstants.basePathSite.rawValue.appending("users/me")) else { throw StoreClientError.InvalidBasePath }
//        return try await executeCall(url, httpMethod: HTTPMethod.POST.rawValue, queryItems: [], credentials: Credentials(key: username, secret: password))
//    }
    
    func login(_ username: String, password: String) async throws -> LoggedUser
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
