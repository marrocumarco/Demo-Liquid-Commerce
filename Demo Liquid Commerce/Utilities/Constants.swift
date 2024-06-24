//
//  StringConstants.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 08/12/2023.
//

import Foundation

enum StringConstants: String {
    case keyChainServerString = "www.demoliquid.it"
    #if DEBUG
    #if targetEnvironment(simulator)
    case basePathStore = "https://localhost/testsite/wp-json/wc/v3/"
    case basePathSite = "https://localhost/testsite/wp-json/wp/v2/"
    case basePathCart = "https://localhost/testsite/wp-json/cocart/v2/"
    #else
    case basePathStore = "https://192.168.0.153/testsite/wp-json/wc/v3/"
    case basePathSite = "https://192.168.0.153/testsite/wp-json/wp/v2/"
    case basePathCart = "https://192.168.0.153/testsite/wp-json/cocart/v2/"
    #endif
    #else
    case basePathStore = "https://www.demoliquid.it/wp-json/wc/v3/"
    case basePathSite = "https://www.demoliquid.it/wp-json/wp/v2/"
    #endif
}
