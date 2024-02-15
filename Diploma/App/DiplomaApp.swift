//
//  DiplomaApp.swift
//  Diploma
//
//  Created by Артём Амаев on 4.02.24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct DiplomaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    //@StateObject var dataModel = DataModel()
    @StateObject var authModel = AuthViewModel()
    @StateObject var testsModel = TestsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authModel)
                .environmentObject(testsModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
      }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
