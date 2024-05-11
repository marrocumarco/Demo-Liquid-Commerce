//
//  AccountView.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 06/05/2024.
//

import SwiftUI

struct ValidationPreferenceKey: PreferenceKey {
    static var defaultValue: [Bool] = []

    static func reduce(value: inout [Bool], nextValue: () -> [Bool]) {
        value += nextValue()
    }
}

struct ValidationModifier: ViewModifier {
    let validation: () -> Bool
    func body(content: Content) -> some View {
        content
            .preference(
                key: ValidationPreferenceKey.self,
                value: [validation()]
            )
    }
}

extension TextField {
   func validate(_ flag: @escaping () -> Bool) -> some View {
      self
         .modifier(ValidationModifier(validation: flag))
   }
}

extension SecureField {
   func validate(_ flag: @escaping () -> Bool) -> some View {
      self
         .modifier(ValidationModifier(validation: flag))
   }
}

struct TextFormView<Content: View>: View {
   @State var validationSeeds: [Bool] = []
   @ViewBuilder var content: (( @escaping () -> Bool)) -> Content
   var body: some View {
         content(validate)
         .onPreferenceChange(ValidationPreferenceKey.self) { value in
            validationSeeds = value
         }
   }

   private func validate() -> Bool {
      for seed in validationSeeds where !seed {
         return false
      }
      return true
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
                    TextFormView { validate in
                        Group {
                            TextField("Username", text: $username).validate {
                                username.count >= 5
                            }.focused($focusedField, equals: .username)
                                .onSubmit {
                                    focusedField = .password
                                }
                            SecureField("Password", text: $password).validate {
                                password.count >= 8
                            }
                            .focused($focusedField, equals: .password)
                                .onSubmit {
                                    focusedField = nil
                                }
                        }
                        Button("Login", action: {
                            Task {
                                await accountViewModel.login(username, password: password)
                            }
                        }).disabled(username.isEmpty || password.isEmpty || !validate())
                            .buttonStyle(.borderedProminent)
                    }.textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                case .userInfo:
                    Text("Hello \(accountViewModel.username), you are logged in")
                    Button("Logout", action: {
                        accountViewModel.logout()
                    })
                case .registration:
                    RegistrationView().navigationTitle("Registration")
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
    @State var newUsername = ""
    @State var name = ""
    @State var surname = ""
    @State var email = ""
    @State var newPassword = ""
    @State var repeatedpassword = ""
    @State var billingAddressToggle = false
    @State var billingName = ""
    @State var billingSurname = ""
    @State var billingCompany = ""
    @State var billingAddress = ""
    @State var billingAddress2 = ""
    @State var billingCity = ""
    @State var billingState = ""
    @State var billingPostcode = ""
    @State var billingCountry = ""
    @State var billingPhone = ""
    @State var billingEmail = ""
    @State var shippingName = ""
    @State var shippingSurname = ""
    @State var shippingCompany = ""
    @State var shippingAddress = ""
    @State var shippingAddress2 = ""
    @State var shippingCity = ""
    @State var shippingState = ""
    @State var shippingPostcode = ""
    @State var shippingCountry = ""
    @State var shippingPhone = ""
    @State var shippingEmail = ""

    @FocusState var focusedField: FocusedField?

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                TextFormView { validate in
                    Group {
                        TextField("Username", text: $newUsername)
                            .validate {
                            !newUsername.isEmpty
                        }.focused($focusedField, equals: .username)
                            .onSubmit {
                                focusedField = .name
                            }
                        TextField("Name", text: $name).validate {
                            !name.isEmpty
                        }
                        .focused($focusedField, equals: .name)
                            .onSubmit {
                                focusedField = .surname
                            }
                        TextField("Surname", text: $surname).validate {
                            !surname.isEmpty
                        }.focused($focusedField, equals: .surname)
                            .onSubmit {
                                focusedField = .email
                            }
                        TextField("Email", text: $email).validate {
                            !email.isEmpty
                        }.focused($focusedField, equals: .email)
                            .onSubmit {
                                focusedField = .password
                            }
                        SecureField("Password", text: $newPassword).validate {
                            !newPassword.isEmpty
                        }.focused($focusedField, equals: .password)
                            .onSubmit {
                                focusedField = .repeatPassword
                            }
                        SecureField("Repeat password", text: $repeatedpassword).validate {
                            !repeatedpassword.isEmpty
                        }.focused($focusedField, equals: .repeatPassword)
                            .onSubmit {
                                focusedField = .shippingName
                            }
                        Spacer()
                        Text("Shipping address")
                        TextField("Name", text: $shippingName)
                            .focused($focusedField, equals: .shippingName)
                            .onSubmit {
                                focusedField = .shippingSurname
                            }
                        TextField("Surname", text: $shippingSurname)
                            .focused($focusedField, equals: .shippingSurname)
                            .onSubmit {
                                focusedField = .shippingCompany
                            }
                        TextField("Company", text: $shippingCompany)
                            .focused($focusedField, equals: .shippingCompany)
                            .onSubmit {
                                focusedField = .shippingCountry
                            }
                        TextField("Country", text: $shippingCountry)
                            .focused($focusedField, equals: .shippingCountry)
                            .onSubmit {
                                focusedField = .shippingStreet
                            }
                        TextField("Street, number", text: $shippingAddress)
                            .focused($focusedField, equals: .shippingStreet)
                            .onSubmit {
                                focusedField = .shippingApartment
                            }
                        TextField("Apartment", text: $shippingAddress2)
                            .focused($focusedField, equals: .shippingApartment)
                            .onSubmit {
                                focusedField = .shippingPostcode
                            }
                        TextField("Postcode", text: $shippingPostcode)
                            .focused($focusedField, equals: .shippingPostcode)
                            .onSubmit {
                                focusedField = .shippingCity
                            }
                        TextField("City", text: $shippingCity)
                            .focused($focusedField, equals: .shippingCity)
                            .onSubmit {
                                focusedField = .shippingState
                            }
                        TextField("State", text: $shippingState)
                            .focused($focusedField, equals: .shippingState)
                            .onSubmit {
                                focusedField = billingAddressToggle ? .billingName : nil
                            }
                        Toggle(
                            "The billing address is different than the shipping address",
                            isOn: $billingAddressToggle
                        ).font(.footnote)
                        Spacer()
                        if billingAddressToggle {
                            Text("Billing address")
                            TextField("Name", text: $billingName)
                                .focused($focusedField, equals: .billingName)
                                .onSubmit {
                                    focusedField = .billingSurname
                                }
                            TextField("Surname", text: $billingSurname)
                                .focused($focusedField, equals: .billingSurname)
                                .onSubmit {
                                    focusedField = .billingCompany
                                }
                            TextField("Company", text: $billingCompany)
                                .focused($focusedField, equals: .billingCompany)
                                .onSubmit {
                                    focusedField = .billingCountry
                                }
                            TextField("Country", text: $billingCountry)
                                .focused($focusedField, equals: .billingCountry)
                                .onSubmit {
                                    focusedField = .billingStreet
                                }
                            TextField("Street, number", text: $billingAddress)
                                .focused($focusedField, equals: .billingStreet)
                                .onSubmit {
                                    focusedField = .billingApartment
                                }
                            TextField("Apartment", text: $billingAddress2)
                                .focused($focusedField, equals: .billingApartment)
                                .onSubmit {
                                    focusedField = .billingPostcode
                                }
                            TextField("Postcode", text: $billingPostcode)
                                .focused($focusedField, equals: .billingPostcode)
                                .onSubmit {
                                    focusedField = .billingCity
                                }
                            TextField("City", text: $billingCity)
                                .focused($focusedField, equals: .billingCity)
                                .onSubmit {
                                    focusedField = .billingState
                                }
                            TextField("State", text: $billingState)
                                .focused($focusedField, equals: .billingState)
                                .onSubmit {
                                    focusedField = .billingPhone
                                }
                                TextField("Phone", text: $billingPhone)
                                    .focused($focusedField, equals: .billingPhone)
                                    .onSubmit {
                                        focusedField = .billingEmail
                                    }
                                TextField("email", text: $billingEmail)
                                    .focused($focusedField, equals: .billingEmail)
                                    .onSubmit {
                                        focusedField = nil
                                    }
                        }
                    }.textFieldStyle(.roundedBorder)
                        .submitLabel(.next)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                    Button("Register") {
                        if !validate() { return }
                    }.buttonStyle(.borderedProminent)
                }
            }.padding(.horizontal)
        }
    }

    enum FocusedField {
        case username
        case name
        case surname
        case password
        case repeatPassword
        case email
        case shippingName
        case shippingSurname
        case shippingCompany
        case shippingCountry
        case shippingStreet
        case shippingApartment
        case shippingPostcode
        case shippingCity
        case shippingState
        case billingName
        case billingSurname
        case billingCompany
        case billingCountry
        case billingStreet
        case billingApartment
        case billingPostcode
        case billingCity
        case billingState
        case billingPhone
        case billingEmail
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
