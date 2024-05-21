//
//  AccountView.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 06/05/2024.
//

import SwiftUI

struct ErrorField<Content: View>: View {
    @Binding var isErrorEnabled: Bool
    let errorMessage: String
    @ViewBuilder var content: () -> Content
    var body: some View {
        content()
            .border(isErrorEnabled ? .red : .clear)
        if isErrorEnabled {
            Text(errorMessage)
                .font(.footnote)
                .foregroundStyle(.red)
        }
    }
}

struct AccountView: View {
    @ObservedObject var accountViewModel: AccountViewModel
    @State var username = ""
    @State var password = ""

    @FocusState var focusedField: FocusedField?

    var body: some View {
        NavigationStack {
            VStack {
                switch accountViewModel.viewStatus {
                case .choiceMenu:
                    Group {
                        Button("Login") {
                            accountViewModel.showLoginForm()
                        }
                        Button("Register", action: {
                            accountViewModel.showRegistrationForm()
                        })
                    }.buttonStyle(.borderedProminent)

                case .loginForm:
                        Group {
                            ErrorField(isErrorEnabled: $accountViewModel.usernameError, errorMessage: "Insert a valid") {
                                TextField("Username", text: $accountViewModel.username)
                                    .focused($focusedField, equals: .username)
                                    .onSubmit {
                                        focusedField = .password
                                    }
                            }
                            ErrorField(isErrorEnabled: $accountViewModel.passwordError, errorMessage: "Insert a valid") {
                                SecureField("Password", text: $accountViewModel.password)
                                    .focused($focusedField, equals: .password)
                                    .onSubmit {
                                        focusedField = nil
                                    }
                            }
                        }
                        Button("Login", action: {
                            Task {
                                await accountViewModel.login(username, password: password)
                            }
                        }).disabled(username.isEmpty || password.isEmpty)
                            .buttonStyle(.borderedProminent)
                    .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                case .userInfo:
                    Text("Hello \(accountViewModel.username), you are logged in")
                    Button("Logout", action: {
                        accountViewModel.logout()
                    })
                case .registration:
                    RegistrationView(accountViewModel: accountViewModel).navigationTitle("Registration")
                case .loginError:
                    Text(accountViewModel.errorCaption)
                }
            }
        }
    }

    enum FocusedField {
        case username
        case password
    }
}

struct RegistrationView: View {

    @FocusState var focusedField: Customer.Field?
    @State var focusedFirstAddressField = false
    @ObservedObject var accountViewModel: AccountViewModel
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                    Group {
                        ErrorField(isErrorEnabled: $accountViewModel.newUsernameError, errorMessage: "Insert a valid") {
                            TextField("Username", text: $accountViewModel.newUsername)
                                .focused($focusedField, equals: Customer.Field.username)
                                .onSubmit {
                                    focusedField = Customer.Field.name
                                }
                        }
                        ErrorField(isErrorEnabled: $accountViewModel.nameError, errorMessage: "Insert a valid") {
                            TextField("Name", text: $accountViewModel.name)
                                .focused($focusedField, equals: Customer.Field.name)
                                .onSubmit {
                                    focusedField = Customer.Field.surname
                                }
                        }
                        ErrorField(isErrorEnabled: $accountViewModel.surnameError, errorMessage: "Insert a valid") {
                            TextField("Surname", text: $accountViewModel.surname)
                                .focused($focusedField, equals: Customer.Field.surname)
                                .onSubmit {
                                    focusedField = Customer.Field.email
                                }
                        }
                        ErrorField(isErrorEnabled: $accountViewModel.emailError, errorMessage: "Insert a valid") {
                            TextField("Email", text: $accountViewModel.email)
                                .focused($focusedField, equals: Customer.Field.email)
                                .onSubmit {
                                    focusedField = Customer.Field.password
                                }
                        }
                        ErrorField(isErrorEnabled: $accountViewModel.newPasswordError, errorMessage: "Insert a valid") {
                            SecureField("Password", text: $accountViewModel.newPassword)
                                .focused($focusedField, equals: Customer.Field.password)
                                .onSubmit {
                                    focusedField = Customer.Field.repeatPassword
                                }
                        }
                        ErrorField(
                            isErrorEnabled: $accountViewModel.repeatedpasswordError,
                            errorMessage: "Insert a valid"
                        ) {
                            SecureField("Repeat password", text: $accountViewModel.repeatedpassword)
                                .focused($focusedField, equals: Customer.Field.repeatPassword)
                                .onSubmit {
                                    focusedField = nil
                                    focusedFirstAddressField = true
                                }
                        }
                        AddressView(focusFirstField: focusedFirstAddressField, accountViewModel: accountViewModel)
                    }.textFieldStyle(.roundedBorder)
                        .submitLabel(.next)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                    Button("Register") {
                        Task {
                            await accountViewModel.registerNewCustomer()
                        }
                    }.buttonStyle(.borderedProminent)
            }.padding(.horizontal)
        }
    }
}

struct AddressView: View {

    @State var focusFirstField: Bool
    @FocusState var focusedField: Address.Field?
    @ObservedObject var accountViewModel: AccountViewModel

    var body: some View {
        Spacer()
        Text("Billing address")
        ErrorField(isErrorEnabled: $accountViewModel.billingNameError, errorMessage: "Insert a valid name") {
            TextField("Name", text: $accountViewModel.billingName)
                .focused($focusedField, equals: Address.Field.name(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.surname(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $accountViewModel.billingSurnameError, errorMessage: "Insert a valid surname") {
            TextField("Surname", text: $accountViewModel.billingSurname)
                .focused($focusedField, equals: Address.Field.surname(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.company(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $accountViewModel.billingCompanyError, errorMessage: "Insert a valid company") {
            TextField("Company", text: $accountViewModel.billingCompany)
                .focused($focusedField, equals: Address.Field.company(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.country(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $accountViewModel.billingCountryError, errorMessage: "Insert a valid country") {
            TextField("Country", text: $accountViewModel.billingCountry)
                .focused($focusedField, equals: Address.Field.country(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.street(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $accountViewModel.billingAddressError, errorMessage: "Insert a valid address") {
            TextField("Street, number", text: $accountViewModel.billingAddress)
                .focused($focusedField, equals: Address.Field.street(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.apartment(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $accountViewModel.billingAddress2Error, errorMessage: "Insert a valid address") {
            TextField("Apartment", text: $accountViewModel.billingAddress2)
                .focused($focusedField, equals: Address.Field.apartment(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.postcode(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $accountViewModel.billingPostcodeError, errorMessage: "Insert a valid postcode") {
            TextField("Postcode", text: $accountViewModel.billingPostcode)
                .focused($focusedField, equals: Address.Field.postcode(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.city(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $accountViewModel.billingCityError, errorMessage: "Insert a valid city") {
            TextField("City", text: $accountViewModel.billingCity)
                .focused($focusedField, equals: Address.Field.city(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.state(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $accountViewModel.billingStateError, errorMessage: "Insert a valid state") {
            TextField("State", text: $accountViewModel.billingState)
                .focused($focusedField, equals: Address.Field.state(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.phone(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $accountViewModel.billingPhoneError, errorMessage: "Insert a valid phone") {
            TextField("Phone", text: $accountViewModel.billingPhone)
                .focused($focusedField, equals: Address.Field.phone(addressType: .billing))
                .onSubmit {
                    focusedField = Address.Field.email(addressType: .billing)
                }
        }
        ErrorField(isErrorEnabled: $accountViewModel.billingEmailError, errorMessage: "Insert a valid email") {
            TextField("email", text: $accountViewModel.billingEmail)
                .focused($focusedField, equals: Address.Field.email(addressType: .billing))
                .onSubmit {
                    focusedField = nil
                }
        }
        Toggle(
            "The billing address is different than the shipping address",
            isOn: $accountViewModel.billingAddressToggle
        ).font(.footnote)
        Spacer()
        if accountViewModel.billingAddressToggle {
            Text("Shipping address")
            ErrorField(isErrorEnabled: $accountViewModel.shippingNameError, errorMessage: "Insert a valid name") {
                TextField("Name", text: $accountViewModel.shippingName)
                    .focused($focusedField, equals: Address.Field.name(addressType: .shipping))
                    .onSubmit {
                        focusedField = Address.Field.surname(addressType: .shipping)
                    }
            }
            ErrorField(isErrorEnabled: $accountViewModel.shippingSurnameError, errorMessage: "Insert a valid surname") {

                TextField("Surname", text: $accountViewModel.shippingSurname)
                    .focused($focusedField, equals: Address.Field.surname(addressType: .shipping))
                    .onSubmit {
                        focusedField = Address.Field.company(addressType: .shipping)
                    }
            }
            ErrorField(isErrorEnabled: $accountViewModel.shippingCompanyError, errorMessage: "Insert a valid company") {
                TextField("Company", text: $accountViewModel.shippingCompany)
                    .focused($focusedField, equals: Address.Field.company(addressType: .shipping))
                    .onSubmit {
                        focusedField = Address.Field.country(addressType: .shipping)
                    }
            }
            ErrorField(isErrorEnabled: $accountViewModel.shippingCountryError, errorMessage: "Insert a valid country") {
                TextField("Country", text: $accountViewModel.shippingCountry)
                    .focused($focusedField, equals: Address.Field.country(addressType: .shipping))
                    .onSubmit {
                        focusedField = Address.Field.street(addressType: .shipping)
                    }
            }
            ErrorField(isErrorEnabled: $accountViewModel.shippingAddressError, errorMessage: "Insert a valid address") {
                TextField("Street, number", text: $accountViewModel.shippingAddress)
                    .focused($focusedField, equals: Address.Field.street(addressType: .shipping))
                    .onSubmit {
                        focusedField = Address.Field.apartment(addressType: .shipping)
                    }
            }
            ErrorField(isErrorEnabled: $accountViewModel.shippingAddress2Error, errorMessage: "Insert a valid address") {
                TextField("Apartment", text: $accountViewModel.shippingAddress2)
                    .focused($focusedField, equals: Address.Field.apartment(addressType: .shipping))
                    .onSubmit {
                        focusedField = Address.Field.postcode(addressType: .shipping)
                    }
            }
            ErrorField(isErrorEnabled: $accountViewModel.shippingPostcodeError, errorMessage: "Insert a valid postcode") {
                TextField("Postcode", text: $accountViewModel.shippingPostcode)
                    .focused($focusedField, equals: Address.Field.postcode(addressType: .shipping))
                    .onSubmit {
                        focusedField = Address.Field.city(addressType: .shipping)
                    }
            }
            ErrorField(isErrorEnabled: $accountViewModel.shippingCityError, errorMessage: "Insert a valid city") {
                TextField("City", text: $accountViewModel.shippingCity)
                    .focused($focusedField, equals: Address.Field.city(addressType: .shipping))
                    .onSubmit {
                        focusedField = Address.Field.state(addressType: .shipping)
                    }
            }
            ErrorField(isErrorEnabled: $accountViewModel.shippingStateError, errorMessage: "Insert a valid state") {
                TextField("State", text: $accountViewModel.shippingState)
                    .focused($focusedField, equals: Address.Field.state(addressType: .shipping))
                    .onSubmit {
                        focusedField = accountViewModel.billingAddressToggle ? Address.Field.name(addressType: .billing) : nil
                    }
            }
        }
    }
}

#Preview {
    AccountView(
        accountViewModel: AccountViewModel(
            mainViewViewModel: MainViewViewModel(
                client: MockStoreClient(),
                parser: StoreParser(),
                authenticationManager: MockAuthenticationManager()
            ),
            client: MockStoreClient()
        )
    )
}
