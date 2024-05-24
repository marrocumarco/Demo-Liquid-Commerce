//
//  AddressView.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 24/05/2024.
//

import SwiftUI

struct AddressView: View {

    @State var focusFirstField: Bool
    @FocusState var focusedField: Address.Field?
    @ObservedObject var addressViewModel: AddressViewModel

    var body: some View {
        Spacer()
        Text("Billing address")
        ErrorField(isErrorEnabled: $addressViewModel.billingNameError, errorMessage: "Insert a valid name") {
            TextField("Name", text: $addressViewModel.billingName)
                .focused($focusedField, equals: Address.Field.name(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.surname(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $addressViewModel.billingSurnameError, errorMessage: "Insert a valid surname") {
            TextField("Surname", text: $addressViewModel.billingSurname)
                .focused($focusedField, equals: Address.Field.surname(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.company(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $addressViewModel.billingCompanyError, errorMessage: "Insert a valid company") {
            TextField("Company", text: $addressViewModel.billingCompany)
                .focused($focusedField, equals: Address.Field.company(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.country(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $addressViewModel.billingCountryError, errorMessage: "Insert a valid country") {
            TextField("Country", text: $addressViewModel.billingCountry)
                .focused($focusedField, equals: Address.Field.country(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.street(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $addressViewModel.billingAddressError, errorMessage: "Insert a valid address") {
            TextField("Street, number", text: $addressViewModel.billingAddress)
                .focused($focusedField, equals: Address.Field.street(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.apartment(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $addressViewModel.billingAddress2Error, errorMessage: "Insert a valid address") {
            TextField("Apartment", text: $addressViewModel.billingAddress2)
                .focused($focusedField, equals: Address.Field.apartment(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.postcode(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $addressViewModel.billingPostcodeError, errorMessage: "Insert a valid postcode") {
            TextField("Postcode", text: $addressViewModel.billingPostcode)
                .focused($focusedField, equals: Address.Field.postcode(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.city(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $addressViewModel.billingCityError, errorMessage: "Insert a valid city") {
            TextField("City", text: $addressViewModel.billingCity)
                .focused($focusedField, equals: Address.Field.city(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.state(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $addressViewModel.billingStateError, errorMessage: "Insert a valid state") {
            TextField("State", text: $addressViewModel.billingState)
                .focused($focusedField, equals: Address.Field.state(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.phone(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $addressViewModel.billingPhoneError, errorMessage: "Insert a valid phone") {
            TextField("Phone", text: $addressViewModel.billingPhone)
                .focused($focusedField, equals: Address.Field.phone(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.email(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $addressViewModel.billingEmailError, errorMessage: "Insert a valid email") {
            TextField("email", text: $addressViewModel.billingEmail)
                .focused($focusedField, equals: Address.Field.email(addressType: .billing))
                .onSubmit {
                    focusedField = nil
                }
        }
        Toggle(
            "The billing address is different than the shipping address",
            isOn: $addressViewModel.billingAddressToggle
        ).font(.footnote)
        Spacer()
        if addressViewModel.billingAddressToggle {
            Text("Shipping address")
            ErrorField(isErrorEnabled: $addressViewModel.shippingNameError, errorMessage: "Insert a valid name") {
                TextField("Name", text: $addressViewModel.shippingName)
                    .focused($focusedField, equals: Address.Field.name(addressType: .shipping))
                    .onSubmit {
                        focusedField = Address.Field.surname(addressType: .shipping)
                    }
            }
            ErrorField(isErrorEnabled: $addressViewModel.shippingSurnameError, errorMessage: "Insert a valid surname") {

                TextField("Surname", text: $addressViewModel.shippingSurname)
                    .focused($focusedField, equals: Address.Field.surname(addressType: .shipping))
                    .onSubmit {
                        focusedField = Address.Field.company(addressType: .shipping)
                    }
            }
            ErrorField(isErrorEnabled: $addressViewModel.shippingCompanyError, errorMessage: "Insert a valid company") {
                TextField("Company", text: $addressViewModel.shippingCompany)
                    .focused($focusedField, equals: Address.Field.company(addressType: .shipping))
                    .onSubmit {
                        focusedField = Address.Field.country(addressType: .shipping)
                    }
            }
            ErrorField(isErrorEnabled: $addressViewModel.shippingCountryError, errorMessage: "Insert a valid country") {
                TextField("Country", text: $addressViewModel.shippingCountry)
                    .focused($focusedField, equals: Address.Field.country(addressType: .shipping))
                    .onSubmit {
                        focusedField = Address.Field.street(addressType: .shipping)
                    }
            }
            ErrorField(isErrorEnabled: $addressViewModel.shippingAddressError, errorMessage: "Insert a valid address") {
                TextField("Street, number", text: $addressViewModel.shippingAddress)
                    .focused($focusedField, equals: Address.Field.street(addressType: .shipping))
                    .onSubmit {
                        focusedField = Address.Field.apartment(addressType: .shipping)
                    }
            }
            ErrorField(
                isErrorEnabled: $addressViewModel.shippingAddress2Error,
                errorMessage: "Insert a valid address"
            ) {
                TextField("Apartment", text: $addressViewModel.shippingAddress2)
                    .focused($focusedField, equals: Address.Field.apartment(addressType: .shipping))
                    .onSubmit {
                        focusedField = Address.Field.postcode(addressType: .shipping)
                    }
            }
            ErrorField(
                isErrorEnabled: $addressViewModel.shippingPostcodeError,
                errorMessage: "Insert a valid postcode"
            ) {
                TextField("Postcode", text: $addressViewModel.shippingPostcode)
                    .focused($focusedField, equals: Address.Field.postcode(addressType: .shipping))
                    .onSubmit {
                        focusedField = Address.Field.city(addressType: .shipping)
                    }
            }
            ErrorField(isErrorEnabled: $addressViewModel.shippingCityError, errorMessage: "Insert a valid city") {
                TextField("City", text: $addressViewModel.shippingCity)
                    .focused($focusedField, equals: Address.Field.city(addressType: .shipping))
                    .onSubmit {
                        focusedField = Address.Field.state(addressType: .shipping)
                    }
            }
            ErrorField(isErrorEnabled: $addressViewModel.shippingStateError, errorMessage: "Insert a valid state") {
                TextField("State", text: $addressViewModel.shippingState)
                    .focused($focusedField, equals: Address.Field.state(addressType: .shipping))
                    .onSubmit {
                        focusedField = addressViewModel.billingAddressToggle ?
                        Address.Field.name(addressType: .billing) : nil
                    }
            }
        }
    }
}
