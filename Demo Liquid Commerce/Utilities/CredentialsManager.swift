//
//  CredentialsManager.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 07/05/2024.
//

import Foundation

struct CredentialsManager {
    #if DEBUG
    static let storeAPIKey = Bundle.main.infoDictionary?["TEST_API_KEY"] as? String ?? ""
    static let storeAPISecret = Bundle.main.infoDictionary?["TEST_API_SECRET"] as? String ?? ""
    #else
    static let storeAPIKey = Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
    static let storeAPISecret = Bundle.main.infoDictionary?["API_SECRET"] as? String ?? ""
    #endif
}
