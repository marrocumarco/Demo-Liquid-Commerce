//
//  HTTPUtilities.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 29/04/2024.
//

import Foundation

public struct HTTPUtilities {

    public static func checkHTTPStatus(_ status: HTTPStatusCode, data: Data) throws {
        switch status.responseType {
        case .informational, .success:
            break
        case .redirection:
            print(try JSONDecoder().decode(StoreClientErrorResponse.self, from: data))
            throw StoreClientError.redirection(statusCode: status.rawValue)
        case .clientError:
            print(try JSONDecoder().decode(StoreClientErrorResponse.self, from: data))
            throw StoreClientError.clientError(statusCode: status.rawValue)
        case .serverError:
            print(try JSONDecoder().decode(StoreClientErrorResponse.self, from: data))
            throw StoreClientError.serverError(statusCode: status.rawValue)
        case .undefined:
            print(try JSONDecoder().decode(StoreClientErrorResponse.self, from: data))
            throw StoreClientError.redirection(statusCode: status.rawValue)
        }
    }
}

enum HTTPMethod: String {
case GET
case POST
case DELETE
case PUT
}
