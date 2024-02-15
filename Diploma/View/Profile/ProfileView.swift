//
//  ProfileView.swift
//  Diploma
//
//  Created by Артём Амаев on 8.02.24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var showingConfirmationAlert = false
    
    var body: some View {
        if let user = viewModel.currentUser {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.userName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
                Section("General") {
                    
                }
                
                Section("Account") {
                    Button {
                        withAnimation {
                            viewModel.signOut()
                        }
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill",
                                        title: "Sign Out",
                                        tintColor: .red)
                    }
                    
                    Button {
                        showingConfirmationAlert = true
                    } label: {
                        SettingsRowView(imageName: "xmark.circle.fill",
                                        title: "Delete Account",
                                        tintColor: .red)
                    }
                    .alert(isPresented: $showingConfirmationAlert) {
                        Alert(
                            title: Text("Are you sure you want to delete account?"),
                            message: Text("This action cannot be undone."),
                            primaryButton: .cancel(Text("Cancel")),
                            secondaryButton: .destructive(Text("Delete")) {
                                Task {
                                    await viewModel.deleteAccount()
                                }
                            }
                        )
                    }
                }
            }
        } else {
            ProgressView()
        }
    }
}

#Preview {
    ProfileView()
}
