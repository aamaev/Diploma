//
//  CardsView.swift
//  Diploma
//
//  Created by Артём Амаев on 15.02.24.
//

import SwiftUI

struct CardsView: View {
    @State var card: Card
    
    @State private var cardOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            if !card.words.isEmpty {
                ForEach(card.words, id: \.self) { word in
                    CardView(title: card.title,
                             word: word,
                             onSwipeLeft: {self.onSwipeLeft(word)},
                             onSwipeRight: {self.onSwipeRight(word)})
                }
            } else {
                VStack {
                    Spacer()
                    Text("🔥")
                        .font(.system(size: 64))
                    Text("You learned all words from this stack")
                        .font(.system(size: 16))
                        .padding()
                        .background(Color("primaryLightViolet"))
                        .cornerRadius(10)
                    Spacer()
                }
            }
        }
        Spacer()
    }

    func onSwipeRight(_ word: Word) {
        if let index = card.words.firstIndex(of: word) {
            card.words.remove(at: index)
            card.words.insert(word, at: 0)
        }
    }
    
    func onSwipeLeft(_ word: Word) {
        if let index = card.words.firstIndex(of: word) {
            card.words.remove(at: index)
        }
    }
}

