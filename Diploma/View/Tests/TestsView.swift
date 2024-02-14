//
//  TestsView.swift
//  Diploma
//
//  Created by Артём Амаев on 8.02.24.
//

import SwiftUI

struct TestsView: View {
    @EnvironmentObject var viewModel: TestsViewModel
    @State private var searchText = ""
        
    var body: some View {
        if viewModel.tests != nil {
            if !(viewModel.tests?.isEmpty ?? true) {
                List {
                    Section(header: Text("Tests").font(.headline)) {
                        ForEach(searchResults, id: \.id) { test in
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
                .searchable(text: $searchText)
            } else {
                ProgressView()
            }
        } else {
            ProgressView()
        }
    }
    
    var searchResults: [Test] {
        if searchText.isEmpty {
            return viewModel.tests ?? []
        } else {
            return (viewModel.tests ?? []).filter { $0.title.contains(searchText) }
        }
    }
}


struct TestDetailView: View {
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

#Preview {
    TestsView()
}


