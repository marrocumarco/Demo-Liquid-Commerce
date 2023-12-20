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
    
    func executeCall<T>(_ endPoint: String, queryItems: [URLQueryItem]) async throws -> [T] where T : Decodable {
        let url = baseURL.appending(path: endPoint)
        var request = URLRequest(url: url.appending(queryItems: queryItems))
        request.allHTTPHeaderFields = getHeaders(url.absoluteString, parameters: queryItems)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let status = (response as? HTTPURLResponse)?.status else { throw StoreClientError.UndefinedHTTPStatusCode }
        
        try checkHTTPStatus(status)
        
#if DEBUG
        print(try JSONSerialization.jsonObject(with: data))
#endif
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([T].self, from: data)
    }
    
    func getHeaders(_ path: String, parameters: [URLQueryItem]) -> [String : String]
    {
        let consumerKey = Bundle.main.infoDictionary?["TEST_API_KEY"] as? String ?? ""
        let consumerSecret = Bundle.main.infoDictionary?["TEST_API_SECRET"] as? String ?? ""
        var parameters = parameters
        var nonce = ""
        for _ in 0..<32
        {
            nonce += ["abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".randomElement()!]
        }
        let timestamp = "\(Int(Date.now.timeIntervalSince1970))"
        parameters.append(URLQueryItem(name: "oauth_consumer_key", value: "\(consumerKey)"))
        parameters.append(URLQueryItem(name: "oauth_timestamp", value: "\(timestamp)"))
        parameters.append(URLQueryItem(name: "oauth_nonce", value: "\(nonce)"))
        parameters.append(URLQueryItem(name: "oauth_signature_method", value: "HMAC-SHA1"))
        // Generate HMAC-SHA1 Signature
        let signature = generateHMACSHA1Signature(consumerSecret: consumerSecret, url: path, parameters: parameters)
        // Add the signature to the request header
        return [
            "Authorization": "OAuth oauth_consumer_key=\"\(consumerKey)\", oauth_signature_method=\"HMAC-SHA1\", oauth_signature=\"\(signature)\", oauth_timestamp=\"\(timestamp)\",oauth_nonce=\"\(nonce)\""
        ]
    }
    
    func generateHMACSHA1Signature(consumerSecret: String, url: String, parameters: [URLQueryItem]) -> String{
        let method = "GET" // or "POST" based on your request method
        let sortedParams = parameters.sorted(by: { $0.name < $1.name })
        
        var parameterString = ""
        for param in sortedParams {
            parameterString += "\(param.name)=\(param.value ?? "")&"
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
}

extension String {
    func urlEncoded() -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert("_")
        characterSet.insert("-")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet) ?? ""
    }
    
    
}
