//
//  RegisterView.swift
//  Diploma
//
//  Created by Артём Амаев on 5.02.24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var userName = ""
    @State private var isValidEmail = true
    @State private var isValidPassword = true
    @State private var isValidUserName = true
    @State private var isConfirmPasswordValid = true
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var canProceed: Bool {
        Validator.validateEmail(email) &&
            Validator.validatePassword(password) &&
                validateConfirm(confirmPassword) &&
                    Validator.validateUserName(userName)
    }
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            Text("RegistrationView.CreateAccount")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color("primaryViolet"))
                .padding(.bottom)
            Text("RegistrationView.ImproveYourEnglish")
                .font(.system(size: 18, weight: .medium))
                .multilineTextAlignment(.center)
                .padding(.bottom, 75)
            
            EmailTextField(email: $email,
                           isValidEmail: $isValidEmail)
            UserNameTextField(userName: $userName,
                              isValidUserName: $isValidUserName,
                              placeholder: "RegistrationView.UserName".localized())
            PasswordTextField(password: $password,
                              isValidPassword: $isValidPassword,
                              errorText: "LoginView.PasswordValid".localized(),
                              placeholder: "LoginView.Password".localized(),
                              validatePassword: Validator.validatePassword)
            
            PasswordTextField(password: $confirmPassword,
                              isValidPassword: $isConfirmPasswordValid,
                              errorText: "LoginView.PasswordValid".localized(),
                              placeholder: "RegistrationView.ConfirmPassword".localized(),
                              validatePassword: validateConfirm)
            
            Button {
                Task {
                    try await viewModel.createUser(withEmail: email,
                                                   password: confirmPassword,
                                                   userName: userName)
                }
            } label: {
                Text("RegistrationView.SignUp")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.vertical)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(Color("primaryViolet"))
            .cornerRadius(12)
            .padding(.horizontal)
            .opacity(canProceed ? 1.0 : 0.5)
            .disabled(!canProceed)
            .padding(.top, 15)
            
            NavigationLink {
                LoginView()
                    .navigationBarBackButtonHidden()
            } label: {
                Text("RegistrationView.AlreadyHaveAccount")
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
    
    func validateConfirm(_ passwordText: String) -> Bool {
        passwordText == password
    }
}

#Preview {
    RegistrationView()
}

struct UserNameTextField: View {
    @Binding var userName: String
    @Binding var isValidUserName: Bool
    let placeholder: String
    
    @FocusState var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            TextField("", text: $userName, prompt: Text(placeholder).foregroundColor(.gray))
                .focused($focusedField, equals: .userName)
                .padding()
                .background(Color("primaryLightViolet"))
                .cornerRadius(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(!isValidUserName ? .red :focusedField == .userName ? Color("themeDark") : .white, lineWidth: 3)
                )
                .padding(.horizontal)
                .onChange(of: userName) { oldValue, newValue in
                    isValidUserName = Validator.validateUserName(newValue)
                }
            
            if !isValidUserName {
                HStack {
                    Text("RegistrationView.UserNameValid")
                        .foregroundColor(.red)
                        .padding(.leading)
                    Spacer()
                }
            }
        }
    }
}
