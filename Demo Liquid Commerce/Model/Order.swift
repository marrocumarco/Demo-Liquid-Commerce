//
//  Order.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 22/04/2024.
//

import Foundation

public struct Order: Codable, Equatable
{
    
    let id: Int?
    let number: Int?
    let customerId: Int?
    let status: String?
    let paymentMethod: String
    let paymentMethodTitle: String
    let setPaid: Bool?
    let billing: Address
    let shipping: Address
    let lineItems: [LineItem]
    let shippingLines: [ShippingLine]
}

