//
//  ContentView.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 17/10/2023.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @ObservedObject var viewModel: MainViewViewModel
    @ObservedObject var cartViewModel = CartViewModel()
    var body: some View {
        TabView {
            ProductsListView(productsListViewModel: ProductsListViewModel(client: viewModel.client,
                                                                          parser: viewModel.parser),
                             cartViewModel: cartViewModel)
            .tabItem {
                Label(LocalizedStringKey("Menu"), systemImage: "wineglass")
            }

            CartView(cartViewModel: cartViewModel)
            // CheckoutView(model: PaymentViewModel(products: cartViewModel.products, paymentClient: StripeClient()))
                .tabItem {
                    Label("Basket", systemImage: "cart")
                }.badge(cartViewModel.itemsInCart)

            AccountView(accountViewModel: AccountViewModel(mainViewViewModel: viewModel, client: BaseAuthClient()))
                .tabItem {
                    Label("Account", systemImage: "person")
                }
        }
    }
}

#Preview {
    MainView(
        viewModel: MainViewViewModel(
            client: OAuthClient(),
            parser: StoreParser(),
            authenticationManager: MockAuthenticationManager()
        )
    )
}
