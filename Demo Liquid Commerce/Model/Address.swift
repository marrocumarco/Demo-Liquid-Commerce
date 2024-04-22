//
//  Address.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 25/01/2024.
//

import Foundation

struct Address: Codable, Equatable
{
    var firstName: String
    var lastName: String
    var company: String?
    var address1: String
    var address2: String
    var city: String
    var state: String
    var postcode: String
    var country: String
    var phone: String?
    var email: String?
    
    enum CodingKeys: String, CodingKey
    {
        case address1Encoding = "address_1"
        case address1Decoding = "address1"
        case address2Encoding = "address_2"
        case address2Decoding = "address2"
        case firstName, lastName, company, city, state, postcode, country, phone, email
    }
    
    internal init(firstName: String, lastName: String, company: String? = nil, address1: String, address2: String, city: String, state: String, postcode: String, country: String, phone: String? = nil, email: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.company = company
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.state = state
        self.postcode = postcode
        self.country = country
        self.phone = phone
        self.email = email
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Address.CodingKeys> = try decoder.container(keyedBy: Address.CodingKeys.self)
        self.firstName = try container.decode(String.self, forKey: Address.CodingKeys.firstName)
        self.lastName = try container.decode(String.self, forKey: Address.CodingKeys.lastName)
        self.company = try container.decodeIfPresent(String.self, forKey: Address.CodingKeys.company)
        self.address1 = try container.decode(String.self, forKey: Address.CodingKeys.address1Decoding)
        self.address2 = try container.decode(String.self, forKey: Address.CodingKeys.address2Decoding)
        self.city = try container.decode(String.self, forKey: Address.CodingKeys.city)
        self.state = try container.decode(String.self, forKey: Address.CodingKeys.state)
        self.postcode = try container.decode(String.self, forKey: Address.CodingKeys.postcode)
        self.country = try container.decode(String.self, forKey: Address.CodingKeys.country)
        self.phone = try container.decodeIfPresent(String.self, forKey: Address.CodingKeys.phone)
        self.email = try container.decodeIfPresent(String.self, forKey: Address.CodingKeys.email)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<Address.CodingKeys> = encoder.container(keyedBy: Address.CodingKeys.self)
        try container.encode(self.firstName, forKey: Address.CodingKeys.firstName)
        try container.encode(self.lastName, forKey: Address.CodingKeys.lastName)
        try container.encodeIfPresent(self.company, forKey: Address.CodingKeys.company)
        try container.encode(self.address1, forKey: Address.CodingKeys.address1Encoding)
        try container.encode(self.address2, forKey: Address.CodingKeys.address2Encoding)
        try container.encode(self.city, forKey: Address.CodingKeys.city)
        try container.encode(self.state, forKey: Address.CodingKeys.state)
        try container.encode(self.postcode, forKey: Address.CodingKeys.postcode)
        try container.encode(self.country, forKey: Address.CodingKeys.country)
        try container.encodeIfPresent(self.phone, forKey: Address.CodingKeys.phone)
        try container.encodeIfPresent(self.email, forKey: Address.CodingKeys.email)
    }
}


