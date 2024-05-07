//
//  AccountViewModel.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 06/05/2024.
//

import Foundation

@MainActor
class AccountViewModel: ObservableObject {

    @Published var username = ""
    @Published var isLoggedIn = false
    @Published var errorCaption = ""

    let client: StoreClient
    unowned let mainViewViewModel: MainViewViewModel

    internal init(mainViewViewModel: MainViewViewModel, client: StoreClient) {
        self.mainViewViewModel = mainViewViewModel
        self.client = client
    }

    func login(_ username: String, password: String) async {
        do {
            let data = try await client.login(username, password: password)
            mainViewViewModel.loggedUser = try mainViewViewModel.parser.parse(data)
            self.username = mainViewViewModel.loggedUser?.displayName ?? ""
            isLoggedIn = true
        } catch {
            errorCaption = "Cannot login, try again."
        }
    }

    func logout() {
        mainViewViewModel.loggedUser = nil
        isLoggedIn = false
    }
}
