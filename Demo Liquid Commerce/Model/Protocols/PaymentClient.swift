//
//  PaymentClient.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 26/04/2024.
//

import Foundation

public protocol PaymentClient
{
    func startCheckout(_ products: [Product]) async throws -> StripeCheckoutResponse
}

public struct StripeClient: PaymentClient
{
    public func startCheckout(_ products: [Product]) async throws -> StripeCheckoutResponse
    {
        let url = URL(string:
        "https://sudden-radial-stygimoloch.glitch.me/checkout")!
        var request = URLRequest (url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(products)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let status = (response as? HTTPURLResponse)?.status else { throw StoreClientError.undefinedHTTPStatusCode }
        
        switch status.responseType{
        case .success:
            return try JSONDecoder().decode(StripeCheckoutResponse.self, from: data)
        default:
            throw StoreClientError.undefinedHTTPStatusCode
        }
        
        
        //try checkHTTPStatus(status) //TODO
        
        
    }
    
   
}

