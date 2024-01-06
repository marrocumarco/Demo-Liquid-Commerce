//
//  MainViewViewModel.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 25/10/2023.
//

import Foundation

enum AuthenticationType
{
    case base
    case oAuth
}

class MainViewViewModel: ObservableObject
{
    let client: StoreClient
    let productListViewModel: ProductsListViewModel
    
    internal init(client: StoreClient) 
    {
        self.client = client
        productListViewModel = ProductsListViewModel(client: client)
    }
}
