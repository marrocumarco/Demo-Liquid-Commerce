//
//  Demo_Liquid_CommerceApp.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 17/10/2023.
//

import SwiftUI
import SwiftData
import Stripe

@main
struct AppLauncher {

    static func main() throws {
        if NSClassFromString("XCTestCase") == nil {
            Demo_Liquid_CommerceApp.main()
        } else {
            TestApp.main()
        }
    }
}

struct Demo_Liquid_CommerceApp: App
{
    init()
    {
        StripeAPI.defaultPublishableKey = Bundle.main.infoDictionary?["TEST_STRIPE_API_KEY"] as? String ?? ""
    }
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewViewModel(client: OAuthClient(), parser: StoreParser()))
        }
    }
}

struct TestApp: App
{
    init()
    {
        StripeAPI.defaultPublishableKey = Bundle.main.infoDictionary?["TEST_STRIPE_API_KEY"] as? String ?? ""
    }
    var body: some Scene {
        WindowGroup {
            Text("Testing...")
        }
    }
}
