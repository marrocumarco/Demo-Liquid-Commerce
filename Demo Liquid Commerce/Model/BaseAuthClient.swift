//
//  Client.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 18/10/2023.
//

import Foundation
struct Credentials
{
    let key: String
    let secret: String
}

struct BaseAuthClient: StoreClient
{
    
    
    func executeCall<T>(_ baseURL: URL, queryItems: [URLQueryItem], credentials: Credentials) async throws -> [T] where T : Decodable {
        let url = baseURL.appending(queryItems: queryItems)
        let encodedCredentials = Data("\(credentials.key):\(credentials.secret)".utf8).base64EncodedString()
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let status = (response as? HTTPURLResponse)?.status else { throw StoreClientError.UndefinedHTTPStatusCode }
            try checkHTTPStatus(status)
//            let _ = Int((response as? HTTPURLResponse)?.allHeaderFields["x-wp-totalpages"] as? String ?? "") ?? 1
    #if DEBUG
            print(try JSONSerialization.jsonObject(with: data))
    #endif
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([T].self, from: data)
    }
}
