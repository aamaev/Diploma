//
//  TestsView.swift
//  Diploma
//
//  Created by Артём Амаев on 8.02.24.
//

import SwiftUI

struct TestsView: View {
    @EnvironmentObject var viewModel: TestsViewModel
        
    var body: some View {
        if viewModel.tests != nil {
            if !(viewModel.tests?.isEmpty ?? true) {
                List {
                    Section("Tests") {
                        ForEach(viewModel.tests ?? []) { test in
                            NavigationLink(destination: TestDetailView(test: test)) {
                                VStack(alignment: .leading) {
                                    Text(test.title)
                                        .font(.headline)
                                    Text(test.rules)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            } else {
                ProgressView()
            }
        } else {
            ProgressView()
        }
    }

}

struct TestDetailView: View {
    var test: Test
    
    @State private var showingResultSheet = false
    @State private var selectedAnswers: [String] = []
    
    var body: some View {
        VStack {
            if !selectedAnswers.isEmpty {
                ForEach(test.questions.indices) { index in
                    QuestionView(
                        question: test.questions[index],
                        selectedAnswer: $selectedAnswers[index]
                    )
                    .padding()
                }
            }
            Button{
                showingResultSheet = true
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
            TestResultView(correctAnswersPercentage: calculateCorrectAnswersPercentage())
                .onAppear {
                    let generator = UIImpactFeedbackGenerator(style: .soft)
                    generator.impactOccurred()
                }
        }
        .onAppear {
            selectedAnswers = Array(repeating: "", count: test.questions.count)
        }
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

struct TestResultView: View {
    var correctAnswersPercentage: Double
    
    var body: some View {
        VStack {
            Text("Test Results")
                .font(.title)
                .padding()
            Text("Correct Answers: \(String(format: "%.1f", correctAnswersPercentage))%")
                .font(.headline)
                .padding()
        }
    }
}


#Preview {
    TestsView()
}


