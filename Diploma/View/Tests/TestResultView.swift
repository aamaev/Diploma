//
//  TestResultView.swift
//  Diploma
//
//  Created by Артём Амаев on 19.02.24.
//

import SwiftUI

struct TestResultView: View {
    var text: String
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
                }
                .padding()
            }
            Text(text)
                .font(.title)
                .padding()
            Text("Correct Answers: \(String(format: "%.1f", correctAnswersPercentage))%")
                .font(.headline)
                .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
