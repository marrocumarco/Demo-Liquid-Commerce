//
//  LoggedUser.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 15/01/2024.
//

import Foundation

struct LoggedUser: Decodable {
    let userId: String
    let displayName: String
    var password: String?
}
