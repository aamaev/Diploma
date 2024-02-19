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
    @Published var testPercentages: [String: Double] = [:]
        
    init() {
        Task {
            await fetchTests()
            await fetchTestPercentages()
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
                let testID = document.documentID
                
                let questionsSnapshot = try await document.reference.collection("questions").getDocuments()
                let questions = try questionsSnapshot.documents.compactMap {
                    try $0.data(as: Question.self)
                }
                
                let test = Test(id: testID, rules: rules, title: title, questions: questions)
                tests.append(test)
            }
            
            self.tests = tests
            self.testPercentages = [:]
        } catch {
            print("DEBUG: Failed to fetch tests with error: \(error.localizedDescription)")
        }
    }
    
    func fetchTestPercentages() async {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        do {
            let userTestResultsRef = Firestore.firestore().collection("users").document(currentUser.uid).collection("testResults")
            let querySnapshot = try await userTestResultsRef.getDocuments()
            
            var percentages: [String: Double] = [:]
            
            for document in querySnapshot.documents {
                if let testId = document["testId"] as? String,
                   let correctAnswersPercentage = document["correctAnswersPercentage"] as? Double {
                    percentages[testId] = correctAnswersPercentage
                }
            }
            
            self.testPercentages = percentages
        } catch {
            print("DEBUG: Failed to fetch test percentages with error \(error.localizedDescription)")
        }
    }
    
    func getTestPersentage(forTestID id: String) -> Double? {
        return testPercentages[id]
    }
    
    func saveTestResult(test: Test, correctAnswersPercentage: Double) async {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        do {
            let userTestResultsRef = Firestore.firestore().collection("users").document(currentUser.uid).collection("testResults")
            
            let testResultDocRef = userTestResultsRef.document(test.id)
            
            let testResultData: [String: Any] = [
                "testId": test.id,
                "testTitle": test.title,
                "correctAnswersPercentage": correctAnswersPercentage,
                "timestamp": FieldValue.serverTimestamp()
            ]
            
            try await testResultDocRef.setData(testResultData)
            await fetchTestPercentages()
            
            print("DEBUG: Test result saved successfully!")
        } catch {
            print("DEBUG: Failed to saving test result with error \(error.localizedDescription)")
        }
    }
    
    
}
