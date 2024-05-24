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
    @Published var password = ""
    @Published var errorCaption = ""
    @Published var viewStatus: Status

    @Published var newUsername = ""
    @Published var name = ""
    @Published var surname = ""
    @Published var email = ""
    @Published var newPassword = ""
    @Published var repeatedpassword = ""

    // Error state

    @Published var usernameError = false
    @Published var passwordError = false
    @Published var errorCaptionError = false
    @Published var newUsernameError = false
    @Published var nameError = false
    @Published var surnameError = false
    @Published var emailError = false
    @Published var newPasswordError = false
    @Published var repeatedpasswordError = false

    @Published var errorFields: [any ValidationField] = []
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

    fileprivate func handleErrorFields(_ errorFields: [Customer.Field]) {
        errorFields.forEach { errorField in
            switch errorField {
            case .username:
                newUsernameError = true
            case .firstName:
                nameError = true
            case .lastName:
                surnameError = true
            case .password:
                newPasswordError = true
            case .email:
                emailError = true
            case .repeatPassword:
                break
            }
        }
    }

    func registerNewCustomer() async {

        var newCustomer = Customer(
            id: nil,
            username: username,
            firstName: name,
            lastName: surname,
            email: email,
            password: password,
            billing: nil,
            shipping: nil)
        do {
            try newCustomer.validate()
            try await client.createNewCustomer(newCustomer)
        } catch  ValidationError.invalidFields(let errorFields) {
            guard let errorFields = errorFields as? [Customer.Field] else { return }
            handleErrorFields(errorFields)
        } catch {}
    }

    enum Status {
        case choiceMenu
        case loginForm
        case userInfo
        case registration
        case loginError
    }
}
