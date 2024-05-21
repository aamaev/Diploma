//
//  LoginView.swift
//  Diploma
//
//  Created by Артём Амаев on 5.02.24.
//

import SwiftUI
import AuthenticationServices

enum FocusedField {
    case email
    case password
    case userName
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isValidEmail = true
    @State private var isValidPassword = true
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var canProceed: Bool {
        Validator.validateEmail(email) && Validator.validatePassword(password)
    }
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("LoginView.LoginHere")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(Color("primaryViolet"))
                    .padding(.bottom)
                Text("LoginView.WelcomeBack")
                    .font(.system(size: 16, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 75)
                
                EmailTextField(email: $email, isValidEmail: $isValidEmail)
                PasswordTextField(password: $password, 
                                  isValidPassword: $isValidPassword,
                                  errorText: "LoginView.PasswordValid".localized(),
                                  placeholder: "LoginView.Password".localized(),
                                  validatePassword: Validator.validatePassword)
                
                Button {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                } label: {
                    Text("LoginView.SignIn")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.vertical)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(Color("primaryViolet"))
                .cornerRadius(12)
                .padding(.horizontal)
                .opacity(canProceed ? 1.0 : 0.5)
                .padding(.top, 15)
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("LoginView.NewAccount")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("themeDark"))
                }
                .padding(.vertical)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .cornerRadius(12)
                .padding(.horizontal)
                
                BottomView()
            }
        }
    }
}

#Preview {
    LoginView()
}

struct BottomView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) private var scheme
    @State private var nonce: String?
    
    var body: some View {
        VStack {
            Text("LoginView.ContinueWith")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color("primaryViolet"))
            HStack {
//                SignInWithAppleButton(.signIn) { request in
//                    let nonce = randomNonceString()
//                    self.nonce = nonce
//                    request.requestedScopes = [.email, .fullName]
//                    request.nonce = sha256(nonce)
//                } onCompletion: { result in
//                    switch result {
//                    case .success(let authorization): 
//                        Task {
//                            try await viewModel.signInWithApple(authorization, currentNonce: nonce)
//                        }
//                    case .failure(let error):
//                        print(error)
//                        break;
//                    }
//                }
//                .signInWithAppleButtonStyle(scheme == .dark ? .white : .black)
//                .frame(width: 200, height: 50)
//                .clipShape(Capsule())
//                .padding()
                
                Button {
                    //action
                } label: {
                    Image("apple-logo")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                .padding()
                .background(Color("vlightGray"))
                .cornerRadius(8)
                
                Button {
                    Task {
                        try await viewModel.signInWithGoogle()
                    }
                } label: {
                    Image("google-logo")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                .padding()
                .background(Color("vlightGray"))
                .cornerRadius(8)
            }
        }
    }
}

struct EmailTextField: View {
    @Binding var email: String
    @Binding var isValidEmail: Bool
    
    @FocusState var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            TextField("", text: $email, prompt: Text("Email").foregroundColor(.gray))
                .keyboardType(.emailAddress)
                .focused($focusedField, equals: .email)
                .padding()
                .background(Color("primaryLightViolet"))
                .cornerRadius(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(!isValidEmail ? .red :focusedField == .email ? Color("themeDark") : .white, lineWidth: 3)
                )
                .padding(.horizontal)
                .onChange(of: email) { oldValue, newValue in
                    isValidEmail = Validator.validateEmail(newValue)
                }
            
            
            if !isValidEmail {
                HStack {
                    Text("LoginView.EmailValid")
                        .foregroundColor(.red)
                        .padding(.leading)
                    Spacer()
                }
            }
        }
    }
}

struct PasswordTextField: View {
    @Binding var password: String
    @Binding var isValidPassword: Bool
    let errorText: String
    let placeholder: String
    let validatePassword: (String) -> Bool
    
    @FocusState var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            SecureField("", text: $password, prompt: Text(placeholder).foregroundColor(.gray))
                .focused($focusedField, equals: .password)
                .padding()
                .background(Color("primaryLightViolet"))
                .cornerRadius(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(!isValidPassword ? .red :focusedField == .password ? Color("themeDark") : .white, lineWidth: 3)
                )
                .padding(.horizontal)
                .onChange(of: password) { oldValue, newValue in
                    isValidPassword = validatePassword(newValue)
                }
            
            
            if !isValidPassword {
                HStack {
                    Text(errorText)
                        .foregroundColor(.red)
                        .padding(.leading)
                    Spacer()
                }
            }
        }
    }
}



