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
                            ErrorField(
                                isErrorEnabled: $accountViewModel.usernameError,
                                errorMessage: "Insert a valid"
                            ) {
                                TextField("Username", text: $accountViewModel.username)
                                    .focused($focusedField, equals: .username)
                                    .onSubmit {
                                        focusedField = .password
                                    }
                            }
                            ErrorField(
                                isErrorEnabled: $accountViewModel.passwordError,
                                errorMessage: "Insert a valid"
                            ) {
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
    @ObservedObject var accountViewModel: AccountViewModel
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                    Group {
                        ErrorField(isErrorEnabled: $accountViewModel.newUsernameError, errorMessage: "Insert a valid") {
                            TextField("Username", text: $accountViewModel.newUsername)
                                .focused($focusedField, equals: Customer.Field.username)
                                .onSubmit {
                                    focusedField = Customer.Field.firstName
                                }
                        }
                        ErrorField(isErrorEnabled: $accountViewModel.nameError, errorMessage: "Insert a valid") {
                            TextField("Name", text: $accountViewModel.name)
                                .focused($focusedField, equals: Customer.Field.firstName)
                                .onSubmit {
                                    focusedField = Customer.Field.lastName
                                }
                        }
                        ErrorField(isErrorEnabled: $accountViewModel.surnameError, errorMessage: "Insert a valid") {
                            TextField("Surname", text: $accountViewModel.surname)
                                .focused($focusedField, equals: Customer.Field.lastName)
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
                                }
                        }
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
