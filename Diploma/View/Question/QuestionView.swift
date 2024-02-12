//
//  QuestionView.swift
//  Diploma
//
//  Created by Артём Амаев on 8.02.24.
//

import SwiftUI

struct QuestionView: View {
    var question: Question
    @Binding var selectedAnswer: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(question.question)")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.bottom, 7)
                .foregroundColor(.black)

            ForEach(question.options, id: \.self) { option in
                Button {
                    selectedAnswer = option
                    print(selectedAnswer)
                } label: {
                    HStack {
                        Text(option)
                            .foregroundColor(.black)
                            .fontWeight(selectedAnswer == option ? .bold : .regular) 
                            .multilineTextAlignment(.leading)
                        Spacer()
                        if selectedAnswer == option {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.vertical, 5)
            }
        }
        .padding(15)
        .background(Color("primaryLightViolet"))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 1.5)
        )
    }
}

