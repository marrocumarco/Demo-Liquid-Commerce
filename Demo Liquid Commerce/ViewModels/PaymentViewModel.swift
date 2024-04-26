//
//  PaymentViewModel.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 26/04/2024.
//
import StripePaymentSheet
import SwiftUI

public class PaymentViewModel: ObservableObject
{
    
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    let products: [Product]
    let paymentClient: PaymentClient
    
    init(products: [Product], paymentClient: PaymentClient)
    {
        self.products = products
        self.paymentClient = paymentClient
    }
    
    func preparePaymentSheet() async throws 
    {
        // MARK: Fetch the PaymentIntent and Customer information from the backend
        let response = try await paymentClient.startCheckout(products)
        
        STPAPIClient.shared.publishableKey = response.publishableKey
        // MARK: Create a PaymentSheet instance
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Example, Inc."
        configuration.customer = .init(id: response.customer, ephemeralKeySecret: response.ephemeralKey)
        // Set `allowsDelayedPaymentMethods` to true if your business can handle payment methods
        // that complete payment after a delay, like SEPA Debit and Sofort.
        configuration.allowsDelayedPaymentMethods = false
        
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: response.paymentIntent ?? "", configuration: configuration)
        
    }
    
    func onPaymentCompletion(result: PaymentSheetResult) 
    {
        self.paymentResult = result
    }
}
