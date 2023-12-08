//
//  Client.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 18/10/2023.
//

import Foundation

struct BaseAuthClient: StoreClient
{
    let baseURL: URL
    
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
    
    public func executeCall<T: Decodable>(_ pathComponent: String) async throws -> [T]
    {
        var numberOfPages = 1
        var pagesDownloaded = 0
        var result = [T]()
        while pagesDownloaded < numberOfPages
        {
            let url = baseURL.appendingPathComponent(pathComponent, conformingTo: .url)
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let credentials = Data("\(Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""):\(Bundle.main.infoDictionary?["API_SECRET"] as? String ?? "")".utf8).base64EncodedString()
            request.setValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let status = (response as? HTTPURLResponse)?.status else { throw StoreClientError.UndefinedHTTPStatusCode }
            try checkHTTPStatus(status)
            numberOfPages = Int((response as? HTTPURLResponse)?.allHeaderFields["x-wp-totalpages"] as? String ?? "") ?? 1
    #if DEBUG
            print(try JSONSerialization.jsonObject(with: data))
    #endif
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            result.append(contentsOf: try decoder.decode([T].self, from: data))
            
            pagesDownloaded += 1
        }
        return result
    }
}
