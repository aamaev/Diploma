//
//  ContentView.swift
//  Diploma
//
//  Created by Артём Амаев on 7.02.24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                MainView()
            } else {
                WelcomeView()
            }
        }
    }
}

#Preview {
    ContentView()
}
