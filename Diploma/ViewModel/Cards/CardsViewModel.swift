//
//  CardsViewModel.swift
//  Diploma
//
//  Created by Артём Амаев on 17.02.24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

@MainActor
class CardsViewModel: ObservableObject {
    @Published var cards: [Card]?
    @Published var userCards: [Card]?
    
    init() {
        Task {
            await fetchCards()
            await fetchUserCards()
        }
    }
    
    func fetchCards() async {
        do {
            let snapshot = try await Firestore.firestore().collection("cards").getDocuments()
            var cards = [Card]()
            
            for document in snapshot.documents {
                let cardDocument = document.data()
                let title = cardDocument["title"] as? String ?? ""
                
                let wordsSnapshot = try await document.reference.collection("words").getDocuments()
                let words = try wordsSnapshot.documents.compactMap {
                    try $0.data(as: Word.self)
                }
                
                let colorString = cardDocument["cardColor"] as? String ?? ""
                let color = Color.colorFromString(colorString)
                
                let card = Card(title: title, words: words, color: color)
                
                cards.append(card)
            }

            
            self.cards = cards
        } catch {
            print("DEBUG: Failed to fetch cards with error: \(error.localizedDescription)")
        }
    }
    
    func fetchUserCards() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        do {
            let userRef = Firestore.firestore().collection("users").document(uid)
            let cardsRef = userRef.collection("cards")

            let querySnapshot = try await cardsRef.getDocuments()

            var cards = [Card]()
            
            for document in querySnapshot.documents {
                let cardDocument = document.data()
                let title = cardDocument["title"] as? String ?? ""
                
                print(title)
                
                let wordsSnapshot = try await document.reference.collection("words").getDocuments()
                let words = try wordsSnapshot.documents.compactMap {
                    try $0.data(as: Word.self)
                }
                
                print(words)
                
                let colorString = cardDocument["cardColor"] as? String ?? ""
                let color = Color.colorFromString(colorString)
                
                let card = Card(title: title, words: words, color: color)
                
                cards.append(card)
            }
            
            self.userCards = cards

        } catch {
            print("DEBUG: Failed to fetch user cards with error: \(error.localizedDescription)")
        }
    }
    
    func addCard(stackName: String, words: [(String, String)]) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            let userRef = Firestore.firestore().collection("users").document(uid)
            let cardsRef = userRef.collection("cards")
            let stackDocRef = cardsRef.document()

            try await stackDocRef.setData(["title": stackName])

            let wordsRef = stackDocRef.collection("words")
            
            for (word, translation) in words {
                let wordData = Word(translate: translation, word: word)
                try wordsRef.addDocument(from: wordData)
            }
        } catch {
            print("DEBUG: Failed to add new cards with error: \(error.localizedDescription)")
        }
    }
    
}

