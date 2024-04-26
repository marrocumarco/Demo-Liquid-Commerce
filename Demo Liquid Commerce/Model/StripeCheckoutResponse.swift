//
//  StripeCheckoutResponse.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 26/04/2024.
//

import Foundation

public struct StripeCheckoutResponse: Decodable
{
    let publishableKey: String
    let paymentIntent: String?
    let customer: String
    let ephemeralKey: String
}
