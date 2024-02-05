//
//  ContentView.swift
//  Diploma
//
//  Created by Артём Амаев on 4.02.24.
//

import SwiftUI

struct MainView: View {
    @State private var presentNextView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("person-learning")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 450)
                    
                Text("Improve your English right now")
                    .font(.system(size: 36, weight: .bold))
                    
            }
            
            
            HStack(spacing: 25) {
                
                Button {
                    presentNextView.toggle()
                } label: {
                    Text("Login")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(width: 160, height: 60)
                .background(Color("primaryViolet"))
                .cornerRadius(12)
                
                
                Button {
                    presentNextView.toggle()
                } label: {
                    Text("Register")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                }
                .frame(width: 160, height: 60)
            }
            .padding()
            .navigationDestination(isPresented: $presentNextView) {
                Text("next view click")
            }
        }
        .padding()
    }
}

#Preview {
    MainView()
}
