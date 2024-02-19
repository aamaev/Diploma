//
//  CardsViewModel.swift
//  Diploma
//
//  Created by Артём Амаев on 17.02.24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor
class CardsViewModel: ObservableObject {
    @Published var cards: [Card]?
    
    init() {
        Task {
            await fetchCards()
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
                
                let card = Card(title: title, words: words)
                
                cards.append(card)
            }
            
            self.cards = cards
        } catch {
            print("DEBUG: Failed to fetch cards with error: \(error.localizedDescription)")
        }
    }
}
