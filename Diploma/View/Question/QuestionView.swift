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
            Text("Select one")
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.bottom, 5)
            VStack(alignment: .leading) {
                Text("\(question.question)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.vertical, 20)
                ForEach(question.options, id: \.self) { option in
                    Button {
                        selectedAnswer = option
                    } label: {
                        HStack {
                            Text(option)
                                .fontWeight(.regular)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color("themeDark"))
                                .padding()
                            Spacer()
                            if selectedAnswer == option {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                                    .padding(5)
                            }
                        }
                        .background(.white)
                        .cornerRadius(10)
                    }
                    .padding(.vertical, 5)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray3))
        .cornerRadius(15)
        .frame(maxWidth: .infinity)
    }
}

