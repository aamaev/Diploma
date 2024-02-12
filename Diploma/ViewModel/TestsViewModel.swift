//
//  TestsViewModel.swift
//  Diploma
//
//  Created by Артём Амаев on 8.02.24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor
class TestsViewModel: ObservableObject {
    @Published var tests: [Test]?
        
    init() {
        Task {
            await fetchTests()
        }
    }
        
    func fetchTests() async {
        do {
            let snapshot = try await Firestore.firestore().collection("tests").getDocuments()
            var tests = [Test]()
            
            for document in snapshot.documents {
                let testDocument = document.data()
                let rules = testDocument["rules"] as? String ?? ""
                let title = testDocument["title"] as? String ?? ""
                
                let questionsSnapshot = try await document.reference.collection("questions").getDocuments()
                let questions = try questionsSnapshot.documents.compactMap {
                    try $0.data(as: Question.self)
                }
                
                let test = Test(rules: rules, title: title, questions: questions)
                tests.append(test)
            }
            
            self.tests = tests
            print(tests)
        } catch {
            print("DEBUG: Failed to fetch tests with error: \(error.localizedDescription)")
        }
    }
}
