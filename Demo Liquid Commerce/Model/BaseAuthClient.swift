//
//  Client.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 18/10/2023.
//

import Foundation

struct BaseAuthClient: StoreClient
{
    public init(basePath: String) throws
    {
        if let url = URL(string: basePath.appending("/wp-json/wc/v3/"))
        {
            baseURL = url
        }
        else
        {
            throw StoreClientError.InvalidBasePath
        }
    }
    
    func fetchCategories() async throws -> [Category] {
        try await executeCall("products/categories")
    }
    
    let baseURL: URL
    
    
    public func fetchProducts() async throws -> [Product]
    {
        try await executeCall("products")
    }
    
    public func executeCall<T: Decodable>(_ pathComponent: String) async throws -> [T]
        {
        let url = baseURL.appendingPathComponent(pathComponent, conformingTo: .url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let credentials = Data("\(Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""):\(Bundle.main.infoDictionary?["API_SECRET"] as? String ?? "")".utf8).base64EncodedString()
        request.setValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        //TODO: - error handling
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([T].self, from: data)
    }
}
