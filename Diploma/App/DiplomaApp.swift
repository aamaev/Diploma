//
//  DiplomaApp.swift
//  Diploma
//
//  Created by Артём Амаев on 4.02.24.
//

import SwiftUI
import FirebaseCore

@main
struct DiplomaApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(viewModel)
        }
    }
}
