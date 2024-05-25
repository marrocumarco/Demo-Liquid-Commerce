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
        return try await executeCall(
            url,
            httpMethod: HTTPMethod.GET.rawValue,
            queryItems: [
                URLQueryItem(name: "page", value: pageNumber.description),
                URLQueryItem(name: "orderby", value: "popularity")],
            httpBody: nil,
            credentials:
                Credentials(
                    key: CredentialsManager.storeAPIKey,
                    secret: CredentialsManager.storeAPISecret
                )
        )
    }

    func fetchCategories() async throws -> Data {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("products/categories")) else {
            throw StoreClientError.invalidBasePath }
        return try await executeCall(url,
                                     httpMethod: HTTPMethod.GET.rawValue,
                                     queryItems: [URLQueryItem(name: "display", value: "subcategories")],
                                     httpBody: nil,
                                     credentials:
                                        Credentials(
                                            key: CredentialsManager.storeAPIKey,
                                            secret: CredentialsManager.storeAPISecret
                                        ))
    }

    func fetchPaymentGateways() async throws -> Data {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("payment_gateways")) else {
            throw StoreClientError.invalidBasePath }
        return try await executeCall(url, httpMethod: HTTPMethod.GET.rawValue, queryItems: [
            URLQueryItem(name: "enabled", value: "true")
        ], httpBody: nil, credentials: Credentials(
            key: CredentialsManager.storeAPIKey,
            secret: CredentialsManager.storeAPISecret
        ))
    }

    func fetchShippingMethods() async throws -> Data {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("shipping_methods")) else {
            throw StoreClientError.invalidBasePath }
        return try await executeCall(url,
                                     httpMethod: HTTPMethod.GET.rawValue,
                                     queryItems: [],
                                     httpBody: nil,
                                     credentials:
                                        Credentials(
                                            key: CredentialsManager.storeAPIKey,
                                            secret: CredentialsManager.storeAPISecret
                                        ))
    }

    @discardableResult
    func createNewCustomer(_ customer: Customer) async throws -> Data {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("customers")) else {
            throw StoreClientError.invalidBasePath }
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let body = try encoder.encode(customer)
        return try await executeCall(url,
                                     httpMethod: HTTPMethod.POST.rawValue,
                                     queryItems: [],
                                     httpBody: body,
                                     credentials:
                                        Credentials(
                                            key: CredentialsManager.storeAPIKey,
                                            secret: CredentialsManager.storeAPISecret
                                        ))
    }

    func updateCustomer(_ customer: Customer) async throws -> Data {
        guard let id = customer.id, let url = URL(string:
                                                    StringConstants.basePathStore.rawValue.appending("customers"))?
            .appending(component: id.description) else {
            throw StoreClientError.invalidBasePath }
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let body = try encoder.encode(customer)
        return try await executeCall(url,
                                     httpMethod: HTTPMethod.PUT.rawValue,
                                     queryItems: [],
                                     httpBody: body,
                                     credentials:
                                        Credentials(
                                            key: CredentialsManager.storeAPIKey,
                                            secret: CredentialsManager.storeAPISecret
                                        ))
    }

    func updateCustomerBillingAddress(_ customerId: Int, address: Address) async throws -> Data {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("customers"))?
            .appending(component: customerId.description) else {
            throw StoreClientError.invalidBasePath }
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        var parameters = [String: Address]()
        parameters[address.addressType == .billing ? "billing" : "shipping"] = address
        let body = try encoder.encode(parameters)
        return try await executeCall(url,
                                     httpMethod: HTTPMethod.PUT.rawValue,
                                     queryItems: [],
                                     httpBody: body,
                                     credentials:
                                        Credentials(
                                            key: CredentialsManager.storeAPIKey,
                                            secret: CredentialsManager.storeAPISecret
                                        ))
    }

    func getCustomers() async throws -> Data {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("customers")) else {
            throw StoreClientError.invalidBasePath }

        return try await executeCall(url,
                                     httpMethod: HTTPMethod.GET.rawValue,
                                     queryItems: [],
                                     httpBody: nil,
                                     credentials:
                                        Credentials(
                                            key: CredentialsManager.storeAPIKey,
                                            secret: CredentialsManager.storeAPISecret
                                        ))
    }

    func getCustomer(_ id: Int) async throws -> Data {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("customers"))?
            .appending(component: id.description) else {
            throw StoreClientError.invalidBasePath }

        return try await executeCall(url,
                                     httpMethod: HTTPMethod.GET.rawValue,
                                     queryItems: [],
                                     httpBody: nil,
                                     credentials:
                                        Credentials(
                                            key: CredentialsManager.storeAPIKey,
                                            secret: CredentialsManager.storeAPISecret
                                        ))
    }

    func login(_ username: String, password: String) async throws -> Data {
        guard let url = URL(string: StringConstants.basePathCart.rawValue.appending("login")) else {
            throw StoreClientError.invalidBasePath }
        return try await executeCall(url,
                                     httpMethod: HTTPMethod.POST.rawValue,
                                     queryItems: [],
                                     httpBody: nil,
                                     credentials: Credentials(key: username, secret: password))
    }

    func createOrder(_ order: Order) async throws -> Data {
        guard let url = URL(string: StringConstants.basePathStore.rawValue.appending("orders")) else { throw
            StoreClientError.invalidBasePath }
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let body = try encoder.encode(order)
        return try await executeCall(url,
                                     httpMethod: HTTPMethod.POST.rawValue,
                                     queryItems: [],
                                     httpBody: body,
                                     credentials:
                                        Credentials(
                                            key: CredentialsManager.storeAPIKey,
                                            secret: CredentialsManager.storeAPISecret
                                        ))
    }

    func getNumberOfItemsInCart(_ customer: Customer) async throws -> Int {
        guard let url = URL(string: StringConstants.basePathCart.rawValue.appending("cart/items/count")) else {
            throw StoreClientError.invalidBasePath }

        let data = try await executeCall(url,
                                     httpMethod: HTTPMethod.GET.rawValue,
                                     queryItems: [],
                                     httpBody: nil,
                                     credentials:
                                            Credentials(key: customer.username,
                                                        secret: customer.password ?? ""))
        return try StoreParser().parse(data)
    }

    func fetchCartTotals(_ customer: Customer) async throws -> CartTotals {
        guard let url = URL(string: StringConstants.basePathCart.rawValue.appending("cart/totals")) else {
            throw StoreClientError.invalidBasePath }

        let data = try await executeCall(url,
                                     httpMethod: HTTPMethod.GET.rawValue,
                                     queryItems: [],
                                     httpBody: nil,
                                     credentials:
                                            Credentials(key: customer.username,
                                                        secret: customer.password ?? ""))
        return try StoreParser().parse(data)
    }

    func calculateCartTotals(_ customer: Customer) async throws -> CalculatedCart {
        guard let url = URL(string: StringConstants.basePathCart.rawValue.appending("cart/calculate")) else {
            throw StoreClientError.invalidBasePath }

        let data = try await executeCall(url,
                                     httpMethod: HTTPMethod.POST.rawValue,
                                     queryItems: [],
                                     httpBody: nil,
                                     credentials:
                                            Credentials(key: customer.username,
                                                        secret: customer.password ?? ""))
        return try StoreParser().parse(data)
    }

    func getCartItems(_ customer: Customer) async throws -> CartDictionary {
        guard let url = URL(string: StringConstants.basePathCart.rawValue.appending("cart/items")) else {
            throw StoreClientError.invalidBasePath }

        let data = try await executeCall(url,
                                     httpMethod: HTTPMethod.GET.rawValue,
                                     queryItems: [],
                                     httpBody: nil,
                                     credentials:
                                            Credentials(key: customer.username,
                                                        secret: customer.password ?? ""))
        return try StoreParser().parse(data)

    }

    func clearCart(_ customer: Customer) async throws -> Data {
        guard let url = URL(string: StringConstants.basePathCart.rawValue.appending("cart/clear")) else {
            throw StoreClientError.invalidBasePath }

        return try await executeCall(url,
                                     httpMethod: HTTPMethod.POST.rawValue,
                                     queryItems: [],
                                     httpBody: nil,
                                     credentials:
                                            Credentials(key: customer.username,
                                                        secret: customer.password ?? ""))
    }

    func addProductToCart(_ customer: Customer, product: Product, quantity: Int?) async throws -> CalculatedCart {
        guard let url = URL(string: StringConstants.basePathCart.rawValue.appending("cart/add-item")) else {
            throw StoreClientError.invalidBasePath }

        var parameters = ["id": product.id.description]
        if let quantity {
            parameters["quantity"] = quantity.description
        }
        let body = try JSONEncoder().encode(parameters)
        let data = try await executeCall(url,
                                     httpMethod: HTTPMethod.POST.rawValue,
                                     queryItems: [],
                                     httpBody: body,
                                     credentials:
                                            Credentials(key: customer.username,
                                                        secret: customer.password ?? ""))
        return try StoreParser().parse(data)
    }

    func removeProductFromCart(_ customer: Customer, item: CartItem) async throws -> Data {
        guard let url = URL(string: StringConstants.basePathCart.rawValue.appending("cart/item/\(item.itemKey)")) else {
            throw StoreClientError.invalidBasePath }

        return try await executeCall(url,
                                     httpMethod: HTTPMethod.DELETE.rawValue,
                                     queryItems: [],
                                     httpBody: nil,
                                     credentials:
                                            Credentials(key: customer.username,
                                                        secret: customer.password ?? ""))
    }

    func updateProductInCart(_ customer: Customer, item: CartItem, quantity: Int?) async throws -> Data {
        guard let url = URL(string: StringConstants.basePathCart.rawValue.appending("cart/item/\(item.itemKey)")) else {
            throw StoreClientError.invalidBasePath }

        var parameters = [String: String]()
        if let quantity {
            parameters["quantity"] = quantity.description
        }
        let body = try JSONEncoder().encode(parameters)

        return try await executeCall(url,
                                     httpMethod: HTTPMethod.POST.rawValue,
                                     queryItems: [],
                                     httpBody: body,
                                     credentials:
                                            Credentials(key: customer.username,
                                                        secret: customer.password ?? ""))
    }
}

enum StoreClientError: Error {
    case invalidBasePath
    case undefinedHTTPStatusCode
    case redirection(statusCode: Int)
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
}

struct StoreClientErrorResponse: Decodable, CustomStringConvertible {
    var description: String {
        "error code: \(code)\nerror message:\(message)"
    }

    let code: String
    let message: String
}
