//
//  StoreClient.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 25/10/2023.
//

import Foundation

protocol StoreClient {
    func executeCall(_ endPoint: URL,
                     httpMethod: String,
                     queryItems: [URLQueryItem],
                     httpBody: Data?,
                     credentials: Credentials) async throws -> Data
}

extension StoreClient {
    func fetchProducts(_ pageNumber: Int) async throws -> Data {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("products")) else {
            throw StoreClientError.invalidBasePath }
        return try await executeCall(url,
                                     httpMethod: HTTPMethod.GET.rawValue,
                                     queryItems: [
                                        URLQueryItem(name: "page", value: pageNumber.description),
                                        URLQueryItem(name: "orderby", value: "popularity")],
                                     httpBody: nil,
                                     credentials: Credentials(key: Bundle.main.infoDictionary?["API_KEY"] as? String ?? "",
                                                              secret: Bundle.main.infoDictionary?["API_SECRET"] as? String ?? ""))
    }

    func fetchCategories() async throws -> Data {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("products/categories")) else {
            throw StoreClientError.invalidBasePath }
        return try await executeCall(url, httpMethod: HTTPMethod.GET.rawValue, queryItems: [
            URLQueryItem(name: "display", value: "subcategories")
        ], httpBody: nil, credentials: Credentials(key: Bundle.main.infoDictionary?["API_KEY"] as? String ?? "", secret: Bundle.main.infoDictionary?["API_SECRET"] as? String ?? ""))
    }
    
    func fetchPaymentGateways() async throws -> Data
    {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("payment_gateways")) else { throw StoreClientError.InvalidBasePath }
        return try await executeCall(url, httpMethod: HTTPMethod.GET.rawValue, queryItems: [
            URLQueryItem(name: "enabled", value: "true")
        ], httpBody: nil, credentials: Credentials(key: Bundle.main.infoDictionary?["API_KEY"] as? String ?? "", secret: Bundle.main.infoDictionary?["API_SECRET"] as? String ?? ""))
    }
    
    func fetchShippingMethods() async throws -> Data
    {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("shipping_methods")) else { throw StoreClientError.InvalidBasePath }
        return try await executeCall(url, httpMethod: HTTPMethod.GET.rawValue, queryItems: [], httpBody: nil, credentials: Credentials(key: Bundle.main.infoDictionary?["API_KEY"] as? String ?? "", secret: Bundle.main.infoDictionary?["API_SECRET"] as? String ?? ""))
    }
    
    func createNewCustomer(_ customer: Customer) async throws -> Data
    {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("customers")) else { throw StoreClientError.InvalidBasePath }
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let body = try encoder.encode(customer)
        return try await executeCall(url, httpMethod: HTTPMethod.POST.rawValue, queryItems: [], httpBody: body, credentials: Credentials(key: Bundle.main.infoDictionary?["API_KEY"] as? String ?? "", secret: Bundle.main.infoDictionary?["API_SECRET"] as? String ?? ""))
    }
    
    func updateCustomer(_ customer: Customer) async throws -> Data
    {
        guard let id = customer.id, let url = URL(string: StringConstants.basePathStore.rawValue.appending("customers"))?.appending(component: id.description) else { throw StoreClientError.InvalidBasePath }
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let body = try encoder.encode(customer)
        return try await executeCall(url, httpMethod: HTTPMethod.PUT.rawValue, queryItems: [], httpBody: body, credentials: Credentials(key: Bundle.main.infoDictionary?["API_KEY"] as? String ?? "", secret: Bundle.main.infoDictionary?["API_SECRET"] as? String ?? ""))
    }
    
    func getCustomers() async throws -> Data
    {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("customers")) else { throw StoreClientError.InvalidBasePath }

        return try await executeCall(url, httpMethod: HTTPMethod.GET.rawValue, queryItems: [], httpBody: nil, credentials: Credentials(key: Bundle.main.infoDictionary?["API_KEY"] as? String ?? "", secret: Bundle.main.infoDictionary?["API_SECRET"] as? String ?? ""))
    }
    
    func getCustomer(_ id: Int) async throws -> Data
    {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("customers"))?.appending(component: id.description) else { throw StoreClientError.InvalidBasePath }

        return try await executeCall(url, httpMethod: HTTPMethod.GET.rawValue, queryItems: [], httpBody: nil, credentials: Credentials(key: Bundle.main.infoDictionary?["API_KEY"] as? String ?? "", secret: Bundle.main.infoDictionary?["API_SECRET"] as? String ?? ""))
    }
    
    func login(_ username: String, password: String) async throws -> Data
    {
        guard let url = URL(string: StringConstants.basePathSite.rawValue.appending("users/me")) else { throw StoreClientError.InvalidBasePath }
        return try await executeCall(url, httpMethod: HTTPMethod.GET.rawValue, queryItems: [], httpBody: nil, credentials: Credentials(key: username, secret: password))
    }
    
    func createOrder(_ order: Order) async throws -> Data
    {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("orders")) else { throw StoreClientError.InvalidBasePath }
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let body = try encoder.encode(order)
        return try await executeCall(url, httpMethod: HTTPMethod.POST.rawValue, queryItems: [], httpBody: body, credentials: Credentials(key: Bundle.main.infoDictionary?["API_KEY"] as? String ?? "", secret: Bundle.main.infoDictionary?["API_SECRET"] as? String ?? ""))
    }
    
    func checkHTTPStatus(_ status: HTTPStatusCode, data: Data) throws {
        switch status.responseType {
        case .informational, .success:
            break
        case .redirection:
            print(try JSONDecoder().decode(StoreClientErrorResponse.self, from: data))
            throw StoreClientError.Redirection(statusCode: status.rawValue)
        case .clientError:
            print(try JSONDecoder().decode(StoreClientErrorResponse.self, from: data))
            throw StoreClientError.ClientError(statusCode: status.rawValue)
        case .serverError:
            print(try JSONDecoder().decode(StoreClientErrorResponse.self, from: data))
            throw StoreClientError.ServerError(statusCode: status.rawValue)
        case .undefined:
            print(try JSONDecoder().decode(StoreClientErrorResponse.self, from: data))
            throw StoreClientError.Redirection(statusCode: status.rawValue)
        }
    }
}

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PUT
}

enum StoreClientError: Error {
    case invalidBasePath
    case undefinedHTTPStatusCode
    case redirection(statusCode: Int)
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
}

struct StoreClientErrorResponse: Decodable, CustomStringConvertible
{
    var description: String{
        "error code: \(code)\nerror message:\(message)"
    }
    
    let code: String
    let message: String
}
