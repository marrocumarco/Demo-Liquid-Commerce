//
//  StoreParser.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 02/03/2024.
//

import Foundation

struct StoreParser: Parser
{
    func parse<T>(_ data: Data) throws -> T where T : Decodable 
    {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}
