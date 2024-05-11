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
    @Published var errorCaption = ""
    @Published var viewStatus: Status

    let client: StoreClient
    unowned let mainViewViewModel: MainViewViewModel

    internal init(mainViewViewModel: MainViewViewModel, client: StoreClient) {
        self.mainViewViewModel = mainViewViewModel
        self.client = client
        self.viewStatus = mainViewViewModel.loggedUser != nil ? .userInfo : .choiceMenu
    }

    func login(_ username: String, password: String) async {
        do {
            let data = try await client.login(username, password: password)
            mainViewViewModel.loggedUser = try mainViewViewModel.parser.parse(data)
            self.username = mainViewViewModel.loggedUser?.displayName ?? ""
            viewStatus = .userInfo
        } catch {
            errorCaption = "Cannot login, try again."
            viewStatus = .loginError
        }
    }

    func showLoginForm() {
        viewStatus = .loginForm
    }

    func showRegistrationForm() {
        viewStatus = .registration
    }

    func logout() {
        mainViewViewModel.loggedUser = nil
        viewStatus = .choiceMenu
    }

    enum Status {
        case choiceMenu
        case loginForm
        case userInfo
        case registration
        case loginError
    }
}
