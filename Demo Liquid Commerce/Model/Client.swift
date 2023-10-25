//
//  Client.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 18/10/2023.
//

import Foundation

struct Client: StoreClient
{
    var baseURL = URL(string: "http://localhost/wordpress/wp-json/wc/v3/")
    
    
    public func fetchProducts() async throws -> [Product]
    {
        if let url = baseURL?.appendingPathComponent("products", conformingTo: .url)
        {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let credentials = Data("\(Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""):\(Bundle.main.infoDictionary?["API_SECRET"] as? String ?? "")".utf8).base64EncodedString()
            request.setValue(credentials, forHTTPHeaderField: "Authorization")

            let (data, response) = try await URLSession.shared.data(for: request)
                   
            return try JSONDecoder().decode([Product].self, from: data)
        }
        return []
    }
}
