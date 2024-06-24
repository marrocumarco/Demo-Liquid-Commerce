//
//  DemoLiquidCommerceApp.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 17/10/2023.
//

import SwiftUI
import SwiftData

@main
struct AppLauncher {
    static func main() throws {
        if NSClassFromString("XCTestCase") == nil {
            DemoLiquidCommerceApp.main()
        } else {
            TestApp.main()
        }
    }
}

struct DemoLiquidCommerceApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(
                viewModel: MainViewViewModel(
                    client: BaseAuthClient(),
                    parser: StoreParser(),
                    authenticationManager: KeyChainManager.instance
                )
            )
        }
    }
}

struct TestApp: App {
    var body: some Scene {
        WindowGroup {
            Text("Testing...")
        }
    }
}
