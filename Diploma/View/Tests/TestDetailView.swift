//
//  TestDetailView.swift
//  Diploma
//
//  Created by Артём Амаев on 19.02.24.
//

import SwiftUI

struct TestDetailView: View {
    @EnvironmentObject var viewModel: TestsViewModel
    
    var test: Test
    
    @State private var showingResultSheet = false
    @State private var selectedAnswers: [String] = []
    @State private var backgroundSheetColor: Color = .red
    
    var body: some View {
        ScrollView {
            VStack {
                if !selectedAnswers.isEmpty && !test.questions.isEmpty {
                    ForEach(test.questions.indices, id: \.self) { index in
                        QuestionView(
                            question: test.questions[index],
                            selectedAnswer: $selectedAnswers[index]
                        )
                        .padding(10)
                    }
                }
                Button{
                    Task {
                        await calculateAndShowResults()
                    }
                } label: {
                    Spacer()
                    Text("Finish test")
                    Spacer()
                }
                .padding()
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundColor(.green)
                .background(Capsule().stroke(.green, lineWidth: 2))
                .frame(width: 250, height: 100)
            }
            .sheet(isPresented: $showingResultSheet) {
                let answersPercentage: Double = calculateCorrectAnswersPercentage()
                
                if (0..<50).contains(answersPercentage) {
                    TestResultView(text: "Not bad, try one more!",
                                   correctAnswersPercentage: answersPercentage,
                                   showingResultSheet: $showingResultSheet)
                    .background(.red)
                } else if (50..<100).contains(answersPercentage) {
                    TestResultView(text: "Wow! Almost perfect!",
                                   correctAnswersPercentage: answersPercentage,
                                   showingResultSheet: $showingResultSheet)
                    .background(Color("primaryLightViolet"))
                } else if answersPercentage == 100 {
                    TestResultView(text: "All answers are correct. Perfect!",
                                   correctAnswersPercentage: answersPercentage,
                                   showingResultSheet: $showingResultSheet)
                    .background(.green)
                } else {
                    ProgressView()
                }
 
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

