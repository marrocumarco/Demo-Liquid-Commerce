//
//  OAuthClient.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 25/10/2023.
//

import Foundation
import CommonCrypto

struct OAuthClient: StoreClient
{
    func generateHMACSHA1Signature(consumerSecret: String, url: String, parameters: [String: Any]) -> String{
        let method = "GET" // or "POST" based on your request method
        let sortedParams = parameters.sorted { $0.0 < $1.0 }
        
        var parameterString = ""
        for (key, value) in sortedParams {
            parameterString += "\(key)=\(value)&"
        }
        parameterString = String(parameterString.dropLast()) // Remove the trailing "&"
        
        let baseString = "\(method)&\(url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")&\(parameterString.urlEncoded())"
        let key = "\(consumerSecret)&" // OAuth1 uses a & symbol
        
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), key, key.count, baseString, baseString.count, &digest)
        
        let signatureData = Data(bytes: digest, count: Int(CC_SHA1_DIGEST_LENGTH))
        
//        let rt = signatureData.map { String(format: "%02hhx", $0) }.joined()
        return signatureData.base64EncodedString()
    }

   
    func fetchProducts() async throws -> [Product]
    {
        let baseUrl = "http://localhost/wordpress/wp-json/wc/v3/products"
        let consumerKey = Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
        let consumerSecret = Bundle.main.infoDictionary?["API_SECRET"] as? String ?? ""
        var parameters: [String: Any] = [:] // Add any additional parameters if needed
        var nonce = ""
        for _ in 0..<32
        {
            nonce += ["abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".randomElement()!]
        }
        let timestamp = "\(Int(Date.now.timeIntervalSince1970))"
        parameters["oauth_consumer_key"] = "\(consumerKey)"
        parameters["oauth_timestamp"] = timestamp
        parameters["oauth_nonce"] = "\(nonce)"
        parameters["oauth_signature_method"] = "HMAC-SHA1"
        // Generate HMAC-SHA1 Signature
        let signature = generateHMACSHA1Signature(consumerSecret: consumerSecret, url: baseUrl, parameters: parameters)
        // Add the signature to the request header
        let headers: [String: String] = [
            "Authorization": "OAuth oauth_consumer_key=\"\(consumerKey)\", oauth_signature_method=\"HMAC-SHA1\", oauth_signature=\"\(signature)\", oauth_timestamp=\"\(timestamp)\",oauth_nonce=\"\(nonce)\""
        ]
        
        var request = URLRequest(url: URL(string: baseUrl)!)
        request.allHTTPHeaderFields = headers
        let (data, response) = try await URLSession.shared.data(for: request)
               
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([Product].self, from: data)

    }
}

extension String {
    func urlEncoded() -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert("_")
        characterSet.insert("-")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet) ?? ""
    }
    
    
}
