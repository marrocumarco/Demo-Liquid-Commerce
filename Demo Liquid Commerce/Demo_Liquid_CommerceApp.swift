//
//  Demo_Liquid_CommerceApp.swift
//  Demo Liquid Commerce
//
//  Created by Marco Marrocu on 17/10/2023.
//

import SwiftUI
import SwiftData

@main
struct Demo_Liquid_CommerceApp: App
{

    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewViewModel())
        }
    }
}
