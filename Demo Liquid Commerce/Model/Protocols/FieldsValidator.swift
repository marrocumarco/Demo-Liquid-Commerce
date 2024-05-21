//
//  FieldsValidator.swift
//  Demo Liquid Commerce
//
//  Created by marrocumarco on 14/05/2024.
//

import Foundation

protocol ValidationField: Hashable {}

protocol FieldsValidator {
    func validate(_ flag: Bool) throws
}

enum ValidationError: Error {
    case invalidFields(errorFields: [any ValidationField])
}
