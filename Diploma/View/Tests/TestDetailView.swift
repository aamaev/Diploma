//
//  TestDetailView.swift
//  Diploma
//
//  Created by Артём Амаев on 19.02.24.
//

import SwiftUI

struct TestDetailView: View {
    @ObservedObject var viewModel = TestsViewModel()
    
    var test: Test
    var rules: String
    
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswers: [String] = []
    @State private var showingResultSheet = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("TestDetailView.Question %d of %d".localized([currentQuestionIndex + 1, test.questions.count]))
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal, 20)
                .padding(.bottom, 5)
            Text(rules.localized())
                .font(.headline)
                .padding(.horizontal, 20)
            Spacer()

            if currentQuestionIndex < test.questions.count && currentQuestionIndex < selectedAnswers.count {
                QuestionView(question: test.questions[currentQuestionIndex], selectedAnswer: $selectedAnswers[currentQuestionIndex])
                    .padding(15)
            }
            
            Spacer()
            
            Button("TestDetailView.Next") {
                if currentQuestionIndex < test.questions.count - 1 {
                    currentQuestionIndex += 1
                } else {
                    Task {
                        await calculateAndShowResults()
                    }
                }
            }
            .font(.subheadline)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .foregroundColor(.gray)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 0.5)
            )
            .padding()
            .sheet(isPresented: $showingResultSheet) {
                TestResultView(correctAnswersPercentage: calculateCorrectAnswersPercentage())
            }
            .onAppear {
                selectedAnswers = Array(repeating: "", count: test.questions.count)
            }
        }
    }
    
    private func calculateAndShowResults() async {
        let answersPercentage: Double = calculateCorrectAnswersPercentage()
        await viewModel.saveTestResult(test: test, correctAnswersPercentage: answersPercentage)
        showingResultSheet = true
    }
    
    private func calculateCorrectAnswersPercentage() -> Double {
        let correctAnswersCount = zip(test.questions, selectedAnswers).reduce(0) {
            count, pair in
            let (question, selectedAnswer) = pair
            return count + (question.answer == selectedAnswer ? 1 : 0)
        }
        return Double(correctAnswersCount) / Double(test.questions.count) * 100
    }
}

