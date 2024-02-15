//
//  CardsView.swift
//  Diploma
//
//  Created by Артём Амаев on 15.02.24.
//

import SwiftUI

struct Card: Hashable {
    let word: String
    let translate: String
}

struct CardsView: View {
    @State var words = [Card(word: "Лето", translate: "Summer"),
                        Card(word: "Зима", translate: "Winter"),
                        Card(word: "Весна", translate: "Spring"),
                        Card(word: "Осень", translate: "Autumn")]
    
    @State private var cardOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            ForEach(words, id: \.self) { word in
                CardView(word: word.word, translate: word.translate)
                    .offset(cardOffset)
                    .frame(width: 300, height: 200)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                self.cardOffset = gesture.translation
                            }
                            .onEnded { gesture in
                                self.cardOffset = .zero
                                
                                if gesture.translation.width > 0 {
                                    self.onSwipeRight(word)
                                } else {
                                    self.onSwipeLeft(word)
                                }
                            }
                    )
            }
        }
    }
    
    func onSwipeRight(_ word: Card) {
        if let index = words.firstIndex(of: word) {
            if index == words.count - 1 {
                words.remove(at: index)
                words.insert(word, at: 0)
            }
        }
    }
    
    func onSwipeLeft(_ word: Card) {
        if let index = words.firstIndex(of: word) {
            words.remove(at: index)
        }
    }
}
#Preview {
    CardsView()
}
