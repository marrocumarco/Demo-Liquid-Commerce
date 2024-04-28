//
//  MainViewViewModel.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 25/10/2023.
//

import Foundation

enum AuthenticationType {
    case base
    case oAuth
}

class MainViewViewModel: ObservableObject {
    let client: StoreClient
    let parser: Parser
    let productListViewModel: ProductsListViewModel

    internal init(client: StoreClient, parser: Parser) {
        self.client = client
        self.parser = parser
        productListViewModel = ProductsListViewModel(client: client, parser: parser)
    }
}
