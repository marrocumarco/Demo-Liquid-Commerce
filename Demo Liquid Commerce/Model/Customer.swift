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

    public func validate() throws {
        var errorFields = [any ValidationField]()
        if username.isEmpty { errorFields.append(Field.username) }
        if firstName.isEmpty { errorFields.append(Field.firstName) }
        if lastName.isEmpty { errorFields.append(Field.lastName) }
        if email.isEmpty { errorFields.append(Field.email) }
        if password?.isEmpty ?? true { errorFields.append(Field.password) }

        if !errorFields.isEmpty { throw ValidationError.invalidFields(errorFields: errorFields) }
    }

    enum Field: ValidationField, Equatable {
        case username
        case firstName
        case lastName
        case password
        case email
        case repeatPassword
    }
}
