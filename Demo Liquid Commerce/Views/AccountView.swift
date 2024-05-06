//
//  AccountView.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 06/05/2024.
//

import SwiftUI

struct AccountView: View {
    @ObservedObject var accountViewModel: AccountViewModel
    @State var username = ""
    @State var password = ""

    var body: some View {
        VStack {
            if !accountViewModel.isLoggedIn {
                TextField("Username", text: $username)
                SecureField("Password", text: $password)
                Button("Login", action: {
                    Task {
                        await accountViewModel.login(username, password: password)
                    }
                }).disabled(username.isEmpty || password.isEmpty)
            } else {
                Text("Hello \(accountViewModel.username), you are logged in")
                Button("Logout", action: {
                    accountViewModel.logout()
                })
            }
        }
    }
}
