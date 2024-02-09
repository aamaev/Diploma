//
//  ApplicationUtility.swift
//  Diploma
//
//  Created by Артём Амаев on 9.02.24.
//

import SwiftUI

class ApplicationUtility {
    static var rootViewController: UIViewController {
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}
