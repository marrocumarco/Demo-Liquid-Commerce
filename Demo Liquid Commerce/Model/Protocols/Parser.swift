//
//  Parser.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 02/03/2024.
//

import Foundation

protocol Parser
{
    func parse<T>(_ data: Data) throws -> T where T: Decodable
}
