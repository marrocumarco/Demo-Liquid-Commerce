//
//  User.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 15/01/2024.
//

import Foundation

struct User: Codable
{
    let id: Int
    let username: String
    let name: String
    let firstName: String
    let lastName: String
    let email: String
    let password: String?
}
