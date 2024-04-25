//
//  ShippingLine.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 22/04/2024.
//

import Foundation

struct ShippingLine: Codable, Equatable
{
    let id: Int?
    let methodTitle: String
    let methodId: String
    let total: String
    let totalTax: String?
}
