//
//  MockStoreClient.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 04/05/2024.
//

import Foundation

struct MockStoreClient: StoreClient {
    func executeCall(_ endPoint: URL,
                     httpMethod: String,
                     queryItems: [URLQueryItem],
                     httpBody: Data?,
                     credentials: Credentials) async throws -> Data {
        Data()
    }
}
