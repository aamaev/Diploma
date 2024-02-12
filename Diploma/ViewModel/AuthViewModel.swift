//
//  AuthViewModel.swift
//  Diploma
//
//  Created by Артём Амаев on 7.02.24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import GoogleSignIn

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to sign it user with error: \(error.localizedDescription)")
        }
    }
    
    func signIn(withCredential credential: AuthCredential) async throws {
        do {
            let result = try await Auth.auth().signIn(with: credential)
            self.userSession = result.user
            let snapshot = try await Firestore.firestore().collection("users").document(result.user.uid).getDocument()
            if snapshot.exists {
                print("DEBUG: User already exists in Firestore")
                let userData = try? snapshot.data(as: User.self)
                self.currentUser = userData
            } else {
                let newUser = User(id: result.user.uid, userName: result.user.displayName ?? "", email: result.user.email ?? "")
                let encodedUser = try Firestore.Encoder().encode(newUser)
                try await Firestore.firestore().collection("users").document(newUser.id).setData(encodedUser)
                await fetchUser()
            }
        } catch {
            print("DEBUG: Failed to sign it user with error: \(error.localizedDescription)")
        }
    }
    
    func signInWithGoogle() async throws {
        do {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            let result = try? await GIDSignIn.sharedInstance.signIn(withPresenting: ApplicationUtility.rootViewController)
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            try await signIn(withCredential: credential)
        } catch {
            print("DEBUG: Failed to google sign in error: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error: \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, userName: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, userName: userName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
        }
    }

    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument()
        else { return }
        
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    func deleteAccount() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            try await Auth.auth().currentUser?.delete()
            try await Firestore.firestore().collection("users").document(uid).delete()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to delete user with error: \(error.localizedDescription)")
        }
    }
    
}

