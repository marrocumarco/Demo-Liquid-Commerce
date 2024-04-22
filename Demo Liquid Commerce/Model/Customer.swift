//
//  Customer.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 29/01/2024.
//

import Foundation

struct Customer: Codable, Equatable
{
    let id: Int?
    var username: String
    var firstName: String
    var lastName: String
    var email: String
    var password: String?
    var billing: Address?
    var shipping: Address?
}
