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
    case basePathStore = "http://localhost/wordpress/wp-json/wc/v3/"
    case basePathSite = "http://localhost/wordpress/wp-json/wp/v2/"
    case basePathCart = "http://localhost/wordpress/wp-json/cocart/v2/"
    #else
    case basePathStore = "https://www.demoliquid.it/wp-json/wc/v3/"
    case basePathSite = "https://www.demoliquid.it/wp-json/wp/v2/"
    #endif
}
