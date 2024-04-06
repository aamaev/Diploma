//
//  CardsView.swift
//  Diploma
//
//  Created by Артём Амаев on 15.02.24.
//

import SwiftUI

struct CardsView: View {
    @State var card: Card

    var body: some View {
        ZStack {
            if !card.words.isEmpty {
                ForEach(card.words.indices, id: \.self) { index in
                    CardView(title: card.title,
                             word: card.words[index],
                             onSwipeLeft: { self.onSwipeLeft(at: index) },
                             onSwipeRight: { self.onSwipeRight(at: index) })
                        .id(UUID())
                }
            } else {
                VStack {
                    Spacer()
                    Text("🔥")
                        .font(.system(size: 64))
                    Text("CardsView.LearnedAllWords")
                        .font(.system(size: 16))
                        .padding()
                        .background(Color("primaryLightViolet"))
                        .cornerRadius(10)
                    Spacer()
                }
            }
        }
    }

    func onSwipeRight(at index: Int) {
        if index < card.words.count {
            let word = card.words.remove(at: index)
            card.words.insert(word, at: 0)
        }
    }

    func onSwipeLeft(at index: Int) {
        if index < card.words.count {
            card.words.remove(at: index)
        }
    }
}

