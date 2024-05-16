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
    @Published var billingAddressToggle = false
    @Published var billingName = ""
    @Published var billingSurname = ""
    @Published var billingCompany = ""
    @Published var billingAddress = ""
    @Published var billingAddress2 = ""
    @Published var billingCity = ""
    @Published var billingState = ""
    @Published var billingPostcode = ""
    @Published var billingCountry = ""
    @Published var billingPhone = ""
    @Published var billingEmail = ""
    @Published var shippingName = ""
    @Published var shippingSurname = ""
    @Published var shippingCompany = ""
    @Published var shippingAddress = ""
    @Published var shippingAddress2 = ""
    @Published var shippingCity = ""
    @Published var shippingState = ""
    @Published var shippingPostcode = ""
    @Published var shippingCountry = ""
    @Published var shippingPhone = ""
    @Published var shippingEmail = ""

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
    @Published var billingNameError = false
    @Published var billingSurnameError = false
    @Published var billingCompanyError = false
    @Published var billingAddressError = false
    @Published var billingAddress2Error = false
    @Published var billingCityError = false
    @Published var billingStateError = false
    @Published var billingPostcodeError = false
    @Published var billingCountryError = false
    @Published var billingPhoneError = false
    @Published var billingEmailError = false
    @Published var shippingNameError = false
    @Published var shippingSurnameError = false
    @Published var shippingCompanyError = false
    @Published var shippingAddressError = false
    @Published var shippingAddress2Error = false
    @Published var shippingCityError = false
    @Published var shippingStateError = false
    @Published var shippingPostcodeError = false
    @Published var shippingCountryError = false
    @Published var shippingPhoneError = false
    @Published var shippingEmailError = false

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

    fileprivate func handleCustomerField(_ errorField: Customer.Field) { 
        switch errorField {
        case .username:
            newUsernameError = true
        case .name:
            nameError = true
        case .surname:
            surnameError = true
        case .password:
            newPasswordError = true
        case .email:
            emailError = true
        case .repeatPassword:
            repeatedpasswordError = true
        }
    }
    // swiftlint:disable cyclomatic_complexity
    fileprivate func handleAddressField(_ errorField: Address.Field) {
        switch errorField {
        case Address.Field.name(addressType: .billing):
            billingNameError = true
        case Address.Field.name(addressType: .shipping):
            billingNameError = true
        case Address.Field.surname(addressType: .billing):
            billingSurnameError = true
        case Address.Field.surname(addressType: .shipping):
            shippingSurnameError = true
        case Address.Field.company(addressType: .billing):
            billingCompanyError = true
        case Address.Field.company(addressType: .shipping):
            shippingCompanyError = true
        case Address.Field.country(addressType: .billing):
            billingCountryError = true
        case Address.Field.country(addressType: .shipping):
            shippingCountryError = true
        case Address.Field.street(addressType: .billing):
            billingAddressError = true
        case Address.Field.street(addressType: .shipping):
            shippingAddressError = true
        case Address.Field.apartment(addressType: .billing):
            billingAddress2Error = true
        case Address.Field.apartment(addressType: .shipping):
            shippingAddress2Error = true
        case Address.Field.postcode(addressType: .billing):
            billingPostcodeError = true
        case Address.Field.postcode(addressType: .shipping):
            shippingPostcodeError = true
        case Address.Field.city(addressType: .billing):
            billingCityError = true
        case Address.Field.city(addressType: .shipping):
            shippingCityError = true
        case Address.Field.state(addressType: .billing):
            billingStateError = true
        case Address.Field.state(addressType: .shipping):
            shippingStateError = true
        case Address.Field.phone(addressType: .billing):
            billingPhoneError = true
        case Address.Field.phone(addressType: .shipping):
            shippingPhoneError = true
        case Address.Field.email(addressType: .billing):
            billingEmailError = true
        case Address.Field.email(addressType: .shipping):
            shippingEmailError = true
        }
    }
    // swiftlint:enable cyclomatic_complexity
    fileprivate func handleErrorFields(_ errorFields: [any ValidationField]) {
        errorFields.forEach {
            if let customerField = $0 as? Customer.Field {
                handleCustomerField(customerField)
            } else if let customerField = $0 as? Address.Field {
                handleAddressField(customerField)
            }
        }
    }

    func registerNewCustomer() async {

        let newCustomer = Customer(
            id: nil,
            username: username,
            firstName: name,
            lastName: surname,
            email: email,
            password: password,
            billing: Address(
                firstName: billingName,
                lastName: billingSurname,
                company: billingCompany,
                address1: billingAddress,
                address2: billingAddress2,
                city: billingCity,
                state: billingState,
                postcode: billingPostcode,
                country: billingCountry,
                phone: billingPhone,
                email: billingEmail,
                addressType: .billing
            ),
            shipping: Address(
                firstName: shippingName,
                lastName: shippingSurname,
                company: shippingCompany,
                address1: shippingAddress,
                address2: shippingAddress2,
                city: shippingCity,
                state: shippingState,
                postcode: shippingPostcode,
                country: shippingCountry,
                phone: shippingPhone,
                email: shippingEmail,
                addressType: .shipping
            ))
        do {
            try newCustomer.validate()
            try await client.createNewCustomer(newCustomer)
        } catch  ValidationError.invalidFields(let errorFields) {
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
