//
//  CartItem.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 01/05/2024.
//

import Foundation

typealias CartDictionary = [String: CartItem]

struct CartItem: Decodable {
    var itemKey: String
    var id: Int
    var name: String
    var title: String
    var price: String
    var quantity: Quantity
    var taxData: TaxData?
    var totals: Totals

    struct Quantity: Decodable {
        var value: Int
        var minPurchase: Int
        var maxPurchase: Int
    }

    struct TaxData: Decodable {
        var subtotal: [Double]
        var total: [Double]
    }

    struct Totals: Decodable {
        var subtotal: String
        var subtotalTax: Int
        var total: Double
        var tax: Double
    }
}
