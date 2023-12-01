//
//  Demo_Liquid_CommerceApp.swift
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
            Demo_Liquid_CommerceApp.main()
        } else {
            TestApp.main()
        }
    }
}

struct Demo_Liquid_CommerceApp: App
{
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewViewModel())
        }
    }
}

struct TestApp: App
{
    var body: some Scene {
        WindowGroup {
            Text("Testing...")
        }
    }
}
