//
//  CardView.swift
//  Diploma
//
//  Created by Артём Амаев on 15.02.24.
//

import SwiftUI

struct CardView: View {
    let word: Word
    
    var onSwipeLeft: () -> Void
    var onSwipeRight: () -> Void
    
    @State private var isOpen: Bool = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 5)
            VStack(alignment: .leading) {
                Text(word.word)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Button(action: {
                    isOpen.toggle()
                }, label: {
                    VStack(alignment: .leading) {
                        Text(word.translate)
                            .font(.headline)
                        Text("[\(word.transcription)]")
                            .font(.subheadline)
                    }
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .blur(radius: isOpen ? 0.2 : 7.0)
                })
                HStack {
                    Button(action: {
                        onSwipeLeft()
                    }) {
                        Text("I already know this word")
                            .font(.subheadline)
                            .foregroundColor(Color("themeDark"))
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    }
                    
                    Text("||")
                    
                    Button(action: {
                        onSwipeRight()
                    }) {
                        Text("Start learning this word")
                            .font(.subheadline)
                            .foregroundColor(Color("themeDark"))
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    }
                }
                .padding(.top, 25)
            }
            .padding(15)
        }
    }
}

