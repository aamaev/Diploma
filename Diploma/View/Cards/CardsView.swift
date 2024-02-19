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
            ForEach(card.words, id: \.self) { word in
                CardView(word: word,
                         onSwipeLeft: {self.onSwipeLeft(word)},
                         onSwipeRight: {self.onSwipeRight(word)})
                    .frame(width: 300, height: 200)
                    .offset(x: cardOffset.width, y: cardOffset.height)
                    .rotationEffect(.degrees(Double(cardOffset.width / 10)))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                self.cardOffset = gesture.translation
                            }
                            .onEnded { gesture in
                                if abs(gesture.translation.width) > 100 {
                                    withAnimation(.easeInOut(duration: 0.6)) {
                                        self.cardOffset = .zero
                                    }
                                    
                                    if gesture.translation.width > 0 {
                                        onSwipeRight(word)
                                    } else {
                                        onSwipeLeft(word)
                                    }
                                } else {
                                    withAnimation(.spring()) {
                                        self.cardOffset = .zero
                                    }
                                }
                            }
                    )
            }
        }
    }

    
    func onSwipeRight(_ word: Word) {
        if let index = card.words.firstIndex(of: word) {
            if index == card.words.count - 1 {
                card.words.remove(at: index)
                card.words.insert(word, at: 0)
            }
        }
    }
    
     func onSwipeLeft(_ word: Word) {
        if let index = card.words.firstIndex(of: word) {
            card.words.remove(at: index)
        }
    }
}

