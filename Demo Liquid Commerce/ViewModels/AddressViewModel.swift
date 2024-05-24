//
//  AddressViewModel.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 24/05/2024.
//

import Foundation

public class AddressViewModel: ObservableObject {
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

    @Published var errorFields: [any ValidationField] = []
    let client: StoreClient

    internal init(client: StoreClient) {
        self.client = client
    }

    func saveAddresses() {

        let billingAddress = Address(
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
        )

        let shippingAddress = Address(
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
        )

        do {
            try billingAddress.validate()
            if billingAddressToggle {
                try shippingAddress.validate()
            }
//            try await client.createNewCustomer(newCustomer) TODO
        } catch  ValidationError.invalidFields(let errorFields) {
            handleErrorFields(errorFields as? [Address.Field] ?? [])
        } catch {}
    }

    // swiftlint:disable cyclomatic_complexity
    fileprivate func handleErrorFields(_ errorFields: [Address.Field]) {
        errorFields.forEach { errorField in
            switch errorField {
            case Address.Field.name(addressType: .billing):
                billingNameError = true
            case Address.Field.name(addressType: .shipping):
                shippingNameError = true
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
    }
    // swiftlint:enable cyclomatic_complexity
}
