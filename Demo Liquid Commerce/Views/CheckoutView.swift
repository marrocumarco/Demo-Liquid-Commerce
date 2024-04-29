//
//  CheckoutView.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 26/04/2024.
//

import SwiftUI
import StripePaymentSheet

struct CheckoutView: View {
    @ObservedObject var model: PaymentViewModel

    var body: some View {
        VStack {
            if let paymentSheet = model.paymentSheet {
                PaymentSheet.PaymentButton(
                    paymentSheet: paymentSheet,
                    onCompletion: model.onPaymentCompletion
                ) {
                    Text("Buy")
                }
            } else {
                Text("Loading…")
            }
            if let result = model.paymentResult {
                switch result {
                case .completed:
                    Text("Payment complete")
                case .failed(let error):
                    Text("Payment failed: \(error.localizedDescription)")
                case .canceled:
                    Text("Payment canceled.")
                }
            }
        }.onAppear {
            Task {
                try await model.preparePaymentSheet()
            }
        }
    }
}
