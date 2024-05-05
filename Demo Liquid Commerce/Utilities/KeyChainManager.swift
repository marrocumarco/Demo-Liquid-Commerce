//
//  KeyChainManager.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 04/05/2024.
//

import Foundation

protocol AuthenticationManager {
    func saveCredentials(_ credentials: Credentials) async throws
    func retrieveCredentials() async throws -> Credentials
    func updateCredentials(_ credentials: Credentials) async throws
    func deleteCredentials() async throws
}

struct MockAuthenticationManager: AuthenticationManager {
    func saveCredentials(_ credentials: Credentials) async throws {}

    func retrieveCredentials() async throws -> Credentials {
        Credentials(key: "mockKey", secret: "mockPassword")
    }

    func updateCredentials(_ credentials: Credentials) async throws {}

    func deleteCredentials() async throws {}
}

struct KeyChainManager: AuthenticationManager {

    private init() {}

    public static let instance = KeyChainManager()

    func saveCredentials(_ credentials: Credentials) async throws {
        let account = credentials.key
        let password = credentials.secret.data(using: String.Encoding.utf8)!
        var query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrServer as String: StringConstants.keyChainServerString.rawValue,
                                    kSecValueData as String: password]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print(SecCopyErrorMessageString(status, nil) as Any)
            throw KeychainError.unhandledError(status: status) }
    }

    func retrieveCredentials() async throws -> Credentials {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: StringConstants.keyChainServerString.rawValue,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else {
            print(SecCopyErrorMessageString(status, nil) as Any)
            throw KeychainError.unhandledError(status: status) }

        guard let existingItem = item as? [String: Any],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(
                data: passwordData,
                encoding: String.Encoding.utf8
              ),
              let account = existingItem[kSecAttrAccount as String] as? String
        else {
            throw KeychainError.unexpectedPasswordData
        }
        return Credentials(
            key: account,
            secret: password
        )
    }

    func updateCredentials(_ credentials: Credentials) async throws {
        let account = credentials.key
        let password = credentials.secret.data(using: String.Encoding.utf8)!
        var query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: StringConstants.keyChainServerString.rawValue]
        var attributes: [String: Any] = [kSecAttrAccount as String: account,
                                    kSecValueData as String: password]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status == errSecSuccess else {
            print(SecCopyErrorMessageString(status, nil) as Any)
            throw KeychainError.unhandledError(status: status) }
    }

    func deleteCredentials() async throws {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: StringConstants.keyChainServerString.rawValue]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            print(SecCopyErrorMessageString(status, nil) as Any)
            throw KeychainError.unhandledError(status: status) }
    }
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
