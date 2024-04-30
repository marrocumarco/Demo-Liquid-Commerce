//
//  CartCalculatedResponse.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 30/04/2024.
//

import Foundation

struct CartCalculatedResponse: Decodable {

    var subtotal: String
    var subtotalTax: Double
    var shippingTotal: String
    var shippingTax: Double
    //    var shipping_taxes: String": {
    //    "12": 6.6
    //  },
    var discountTotal: Double
    var discountTax: Double
    var cartContentsTotal: String
    var cartContentsTax: Double
    // var cart_contents_taxes: String
    //    "12": 8.4
    //  },
    var feeTotal: String
    var feeTax: Double
    var feeTaxes: [Double]
    var total: String
    var totalTax: Int
}
