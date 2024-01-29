//
//  Address.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 25/01/2024.
//

import Foundation

struct Address: Codable
{
    let firstName: String
    let lastName: String
    let company: String?
    let address1: String
    let address2: String
    let city: String
    let state: String
    let postcode: String
    let country: String
    let phone: String?
    let email: String?
}


