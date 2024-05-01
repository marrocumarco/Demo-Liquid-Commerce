//
//  CalculatedCART.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 01/05/2024.
//

import Foundation

struct CalculatedCart: Decodable {
    var totals: CalculatedCartTotals

    struct CalculatedCartTotals: Decodable {

        var subtotal: String
        var subtotalTax: String
        var shippingTotal: String
        var shippingTax: String
        var discountTotal: String
        var discountTax: String
        var feeTotal: String
        var feeTax: String
        var total: String
        var totalTax: String
    }
}
