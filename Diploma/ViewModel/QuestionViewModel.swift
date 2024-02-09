//
//  QuestionViewModel.swift
//  Diploma
//
//  Created by Артём Амаев on 8.02.24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor
class QuestionViewModel: ObservableObject {
    @Published var questions: [Question]?
    
    init() {
        Task {
            await fetchQuestions()
        }
    }
    
    func fetchQuestions() async {
        do {
            let snapshot = try await Firestore.firestore().collection("quiz").document("info").collection("questions").getDocuments()
            self.questions = try snapshot.documents.compactMap {
                try $0.data(as: Question.self)
            }
        } catch {
                print("DEBUG: Failed to fetch question with error: \(error.localizedDescription)")
        }
    }
    
}
