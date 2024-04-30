//
//  CartView.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 26/04/2024.
//

import SwiftUI

public struct CartView: View {

    let cartViewModel: CartViewModel
    public var body: some View {
        Text("This is the Cart")

        Text("number of products: \(cartViewModel.itemsInCart)")

        Button("Checkout", action: {

        })
    }
}
