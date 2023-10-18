//
//  Client.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 18/10/2023.
//

import Foundation
import CommonCrypto

protocol StoreClient
{
    func fetchProducts()
}

struct Client: StoreClient
{
    var baseURL = URL(string: "http://localhost/wordpress/wp-json/wc/v3/")
    
    
    public func fetchProducts()
    {
        if let url = baseURL?.appendingPathComponent("products", conformingTo: .url)
        {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let credentials = Data("\(Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""):\(Bundle.main.infoDictionary?["API_SECRET"] as? String ?? "")".utf8).base64EncodedString()
            request.setValue(credentials, forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request)
            {
                data, response, error in
                
                if let error
                {
                    fatalError("TODO handle error")
                }
                
                guard let data else{ fatalError("TODO handle no data")}
                
                do
                {
                    let products = try JSONDecoder().decode([Product].self, from: data)
                    print(products)
                }
                catch
                {
                    fatalError("TODO handle parse failure")
                }
            }
            task.resume()
        }
    }
}

struct UnsecureTestClient: StoreClient
{
    func generateHMACSHA1Signature(consumerSecret: String, url: String, parameters: [String: Any]) -> String {
        let method = "GET" // or "POST" based on your request method
        let sortedParams = parameters.sorted { $0.0 < $1.0 }
        
        var parameterString = ""
        for (key, value) in sortedParams {
            parameterString += "\(key)=\(value)&"
        }
        parameterString = String(parameterString.dropLast()) // Remove the trailing "&"
        
        let baseString = "\(method)&\(url.urlEncoded())&\(parameterString.urlEncoded())"
        let key = "\(consumerSecret)&" // OAuth1 uses a & symbol
        
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), key, key.count, baseString, baseString.count, &digest)
        
        let signatureData = Data(digest)
        return signatureData.base64EncodedString()
    }

   
    func fetchProducts() {
        let baseUrl = "http://localhost/wordpress/wp-json/wc/v3/products"
        let consumerKey = Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
        let consumerSecret = Bundle.main.infoDictionary?["API_SECRET"] as? String ?? ""
        var parameters: [String: Any] = [:] // Add any additional parameters if needed
        
        // Generate HMAC-SHA1 Signature
        let signature = generateHMACSHA1Signature(consumerSecret: consumerSecret, url: baseUrl, parameters: parameters)
        
        // Add the signature to the request header
        let headers: [String: String] = [
            "Authorization": "OAuth oauth_consumer_key=\"\(consumerKey)\", oauth_signature_method=\"HMAC-SHA1\", oauth_signature=\"\(signature)\", oauth_timestamp=\"(1697662652)\",oauth_nonce=\"NzyDJgtvnnM\",oauth_version=\"1.0\""
        ]
        
        var request = URLRequest(url: URL(string: baseUrl)!)
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error
            {
                fatalError("TODO handle error")
            }
            
            guard let data else{ fatalError("TODO handle no data")}
            
            do
            {
                let products = try JSONDecoder().decode([Product].self, from: data)
                print(products)
            }
            catch
            {
                fatalError("TODO handle parse failure")
            }
        }
        
        task.resume()
    }
    
}

extension String {
    func urlEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}
