//
//  SignAppApp.swift
//  SignApp
//
//  Created by Artem on 30.04.2021.
//

import SwiftUI

@main
struct SignApp: App {
    var body: some Scene {
        WindowGroup {
            SignView(viewModel: SignViewModel())
        }
    }
}
