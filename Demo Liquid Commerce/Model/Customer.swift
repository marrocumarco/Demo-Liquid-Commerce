//
//  Customer.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 29/01/2024.
//

import Foundation

struct Customer: Codable, Equatable, FieldsValidator {
    let id: Int?
    var username: String
    var firstName: String
    var lastName: String
    var email: String
    var password: String?
    var billing: Address?
    var shipping: Address?

    public func validate(_ shippingAddressIsDifferentThanBilling: Bool) throws {
        var errorFields = [any ValidationField]()
        if username.isEmpty { errorFields.append(Field.username) }
        if firstName.isEmpty { errorFields.append(Field.name) }
        if lastName.isEmpty { errorFields.append(Field.surname) }
        if email.isEmpty { errorFields.append(Field.email) }
        if password?.isEmpty ?? true { errorFields.append(Field.password) }
        do {
            try billing?.validate()
        } catch ValidationError.invalidFields(let addressErrorFields) {
            errorFields.append(contentsOf: addressErrorFields)
        }
        if shippingAddressIsDifferentThanBilling {
            do {
                try shipping?.validate()
            } catch ValidationError.invalidFields(let addressErrorFields) {
                errorFields.append(contentsOf: addressErrorFields)
            }
        }
        if !errorFields.isEmpty { throw ValidationError.invalidFields(errorFields: errorFields) }
    }

    enum Field: ValidationField, Equatable {
        case username
        case name
        case surname
        case password
        case email
        case repeatPassword
    }
}
