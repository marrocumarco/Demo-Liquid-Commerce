//
//  PaymentGateway.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 22/04/2024.
//

import Foundation

public struct PaymentGateway: Decodable {
    let id: String
    let title: String
    let description: String
}
