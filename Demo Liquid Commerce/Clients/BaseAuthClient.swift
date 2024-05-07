//
//  Client.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 18/10/2023.
//

import Foundation
struct Credentials: Equatable {
    let key: String
    let secret: String
}

struct BaseAuthClient: StoreClient {

    func executeCall(_ endPoint: URL,
                     httpMethod: String,
                     queryItems: [URLQueryItem],
                     httpBody: Data? = nil,
                     credentials: Credentials) async throws -> Data {
        let url = endPoint.appending(queryItems: queryItems)
        let encodedCredentials = Data("\(credentials.key):\(credentials.secret)".utf8).base64EncodedString()
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Basic \(encodedCredentials)", forHTTPHeaderField: "Authorization")
        if let httpBody {
            request.setValue("\(httpBody.count)", forHTTPHeaderField: "Content-Length")
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = httpBody
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let status = (response as? HTTPURLResponse)?.status else { throw
            StoreClientError.undefinedHTTPStatusCode }
        try HTTPUtilities.checkHTTPStatus(status, data: data)
        // let _ = Int((response as? HTTPURLResponse)?.allHeaderFields["x-wp-totalpages"] as? String ?? "") ?? 1
        return data
    }
}
