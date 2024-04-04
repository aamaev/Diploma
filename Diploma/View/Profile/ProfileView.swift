//
//  ProfileView.swift
//  Diploma
//
//  Created by Артём Амаев on 8.02.24.
//

import SwiftUI
import SDWebImageSwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var showingConfirmationAlert = false
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        if let user = viewModel.currentUser {
            List {
                Section {
                    HStack {
                        Button {
                            showingImagePicker.toggle()
                        } label: {
                            VStack {
                                if let image = viewModel.currentUser?.profilePictureURL {
                                    WebImage(url: URL(string: image))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(30)
                                        .padding(4)
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .font(.system(size: 60))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.userName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        .sheet(isPresented: $showingImagePicker, onDismiss: nil) {
                            ImagePicker(image: self.$selectedImage)
                                .onDisappear {
                                    if let image = selectedImage {
                                        Task {
                                            await viewModel.uploadProfilePicture(image: image)
                                        }
                                        selectedImage = nil
                                    }
                                }
                        }
                    }
                    VStack {
                        if let progress = user.progress {
                            let currentProgress = Int((Int(progress.truncatingRemainder(dividingBy: 100)) >= 100) ? Int(progress - 100) : Int(progress.truncatingRemainder(dividingBy: 100)))
                            
                            ProgressView(value: Float(currentProgress), total: 100) {
                                Text("Level \(Int(progress / 100))")
                            } currentValueLabel: {
                                Text("Current Progress: \(currentProgress)")
                            }
                        }
                    }
                }
                
                Section("General") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
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
            .refreshable {
                Task {
                    await viewModel.fetchUser()
                }
            }
        } else {
            ProgressView()
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
