//
//  DataModel.swift
//  Diploma
//
//  Created by Артём Амаев on 15.02.24.
//

import Foundation

@MainActor
class DataModel: ObservableObject {
    @Published var authViewModel: AuthViewModel?
    @Published var testsViewModel: TestsViewModel?
    
    init() {
        Task {
            self.authViewModel = AuthViewModel()
            self.testsViewModel = TestsViewModel()
        }
    }
}

