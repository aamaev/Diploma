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
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var questionViewModel = QuestionViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(questionViewModel)
        }
    }
}
