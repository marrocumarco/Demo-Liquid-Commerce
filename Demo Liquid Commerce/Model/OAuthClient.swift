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
    
    let baseURL: URL
    
    func getHeaders(_ path: String) -> [String : String]
    {
        let consumerKey = Bundle.main.infoDictionary?["TEST_API_KEY"] as? String ?? ""
        let consumerSecret = Bundle.main.infoDictionary?["TEST_API_SECRET"] as? String ?? ""
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
        let signature = generateHMACSHA1Signature(consumerSecret: consumerSecret, url: path, parameters: parameters)
        // Add the signature to the request header
        return [
            "Authorization": "OAuth oauth_consumer_key=\"\(consumerKey)\", oauth_signature_method=\"HMAC-SHA1\", oauth_signature=\"\(signature)\", oauth_timestamp=\"\(timestamp)\",oauth_nonce=\"\(nonce)\""
        ]
    }
    
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
        return try await executeCall("products")
    }
    
    func fetchCategories() async throws -> [Category] {
        return try await executeCall("products/categories")
    }
    
    func executeCall<T: Decodable>(_ pathComponent: String) async throws -> [T]
    {
        let url = baseURL.appending(path: pathComponent)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = getHeaders(url.absoluteString)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let status = (response as? HTTPURLResponse)?.status else { throw StoreClientError.UndefinedHTTPStatusCode }
        
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
        
#if DEBUG
        print(try JSONSerialization.jsonObject(with: data))
#endif
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([T].self, from: data)
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
