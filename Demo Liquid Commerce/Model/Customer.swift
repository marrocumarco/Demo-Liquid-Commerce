//
//  Customer.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 29/01/2024.
//

import Foundation

struct Customer: Codable
{
    let id: Int?
    let username: String
    let firstName: String
    let lastName: String
    let email: String
    let password: String?
    let billing: Address?
    let shipping: Address?
}
