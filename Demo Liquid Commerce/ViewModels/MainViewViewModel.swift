//
//  MainViewViewModel.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 25/10/2023.
//

import Foundation
import os

enum AuthenticationType {
    case base
    case oAuth
}

class MainViewViewModel: ObservableObject {

    internal init(client: StoreClient, parser: Parser, authenticationManager: AuthenticationManager) {
        self.client = client
        self.parser = parser
        self.authenticationManager = authenticationManager
        productListViewModel = ProductsListViewModel(client: client, parser: parser)
    }

    let client: StoreClient
    let parser: Parser
    let authenticationManager: AuthenticationManager
    let productListViewModel: ProductsListViewModel

    var loggedUser: LoggedUser?

    func tryLogin() async {

        var credentials: Credentials?
        do {
            credentials = try await authenticationManager.retrieveCredentials()
        } catch {
            Logger().info("Missing credentials, cannot try login")
        }
        do {
            loggedUser = try parser.parse(try await client.login(credentials!.key, password: credentials!.secret))
        } catch {
            Logger().info("Login failed")
        }
    }
}
