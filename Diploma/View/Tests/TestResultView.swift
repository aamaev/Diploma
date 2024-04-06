//
//  TestResultView.swift
//  Diploma
//
//  Created by Артём Амаев on 19.02.24.
//

import SwiftUI

struct TestResultView: View {
    var correctAnswersPercentage: Double
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    .padding()
                }

                Text("TestResultView.CorrectAnswers %@".localized(String(format: "%.0f", correctAnswersPercentage)))
                    .font(.headline)
                    .padding()
                
                if (0..<50).contains(correctAnswersPercentage) {
                    VStack {
                        Text("TestResultView.TryMoreTime")
                        Image("person-sad")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .font(.title)
                    .padding(.horizontal, 30)
                } else if (50..<100).contains(correctAnswersPercentage) {
                    VStack {
                        Text("TestResultView.AlmostPerfect")
                        Image("person-sad")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .font(.title)
                    .padding(.horizontal, 30)
                } else {
                    VStack {
                        Text("TestResultView.AllCorrect")
                        Image("person-happy")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .font(.title)
                    .padding(.horizontal, 30)
                }
                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("TestResultView.Exit")
                })
                .buttonStyle(.bordered)
                .tint(.black)
        
                Spacer()
            }
            .background(LinearGradient(gradient: Gradient(colors: [correctAnswersPercentage > 50 ? .green : .brown, .white]), startPoint: .top, endPoint: .bottom))
            .navigationBarHidden(true)
        }
    }
}
