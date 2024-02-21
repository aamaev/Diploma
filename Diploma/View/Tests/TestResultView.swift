//
//  TestResultView.swift
//  Diploma
//
//  Created by Артём Амаев on 19.02.24.
//

import SwiftUI

struct TestResultView: View {
    var correctAnswersPercentage: Double
    
    @Binding var showingResultSheet: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(action: {
                    showingResultSheet = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .padding()
            }

            Text("Correct Answers: \(String(format: "%.0f", correctAnswersPercentage))%")
                .font(.headline)
                .padding()
            
            if (0..<50).contains(correctAnswersPercentage) {
                VStack {
                    Text("Not bad, but try one more time!")
                    Text("🤔")
                }
                .font(.title)
                .padding(.horizontal, 30)
            } else if (50..<100).contains(correctAnswersPercentage) {
                VStack {
                    Text("Wow! Almost perfect!")
                    Text("🤗")
                }
                .font(.title)
                .padding(.horizontal, 30)
            } else {
                VStack {
                    Text("All answers are correct. Perfect!")
                    Text("😎")
                }
                .font(.title)
                .padding(.horizontal, 30)
            }
                
            Spacer()
        }
        .background(correctAnswersPercentage > 50 ? .mint : .brown)
    }
}
