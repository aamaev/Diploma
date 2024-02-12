//
//  LoginView.swift
//  Diploma
//
//  Created by Артём Амаев on 5.02.24.
//

import SwiftUI

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
                Text("Login Here")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(Color("primaryViolet"))
                    .padding(.bottom)
                Text("Welcome back you've\n been missed!")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 75)
                
                EmailTextField(email: $email, isValidEmail: $isValidEmail)
                PasswordTextField(password: $password, 
                                  isValidPassword: $isValidPassword,
                                  errorText: "Your password is not valid.",
                                  placeholder: "Password",
                                  validatePassword: Validator.validatePassword)
                
                Button {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                } label: {
                    Text("Sign in")
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
                    Text("Create new account")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
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
    
    var body: some View {
        VStack {
            Text("Or continue with")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color("primaryViolet"))
            HStack {
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
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .focused($focusedField, equals: .email)
                .padding()
                .background(Color("primaryLightViolet"))
                .cornerRadius(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(!isValidEmail ? .red :focusedField == .email ? Color("primaryViolet") : .white, lineWidth: 3)
                )
                .padding(.horizontal)
                .onChange(of: email) { oldValue, newValue in
                    isValidEmail = Validator.validateEmail(newValue)
                }
            
            if !isValidEmail {
                HStack {
                    Text("Your email is not valid!")
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
            SecureField(placeholder, text: $password)
                .focused($focusedField, equals: .password)
                .padding()
                .background(Color("primaryLightViolet"))
                .cornerRadius(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(!isValidPassword ? .red :focusedField == .password ? Color("primaryViolet") : .white, lineWidth: 3)
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


