//
//  CardView.swift
//  Diploma
//
//  Created by Артём Амаев on 15.02.24.
//

import SwiftUI

struct CardView: View {
    let title: String
    let word: Word
    
    var onSwipeLeft: () -> Void
    var onSwipeRight: () -> Void
    
    @State private var isOpen: Bool = false

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Cards: \(title)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
 
            
            Text(word.word)
                .font(.system(size: 32, weight: .bold))
                .padding(.vertical, 25)
            
            spoiler

            Spacer()
            
            Divider()
            
            bottomButtons
                .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemGray3))
        .cornerRadius(15)
        .frame(maxWidth: .infinity)
        .shadow(radius: 5)
    }
    
    
    var spoiler: some View {
        Button {
            isOpen = true
        } label: {
            if isOpen {
                HStack {
                    VStack(alignment: .leading) {
                        Text(word.translate)
                            .font(.title)
                            .foregroundColor(.black)
                        Text("[\(word.transcription)]")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        ForEach(word.usage, id: \.self) { sentence in
                            Text(sentence)
                                .padding(.vertical, 10)
                        }
                    }
                    .padding()
                    
                    Spacer()
                }                
            } else {
                Image(systemName: "eye")
                    .foregroundColor(Color(.black))
                    .font(.title)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    
    var bottomButtons: some View {
        HStack {
            Button(action: {
                onSwipeLeft()
            }) {
                Text("I already know this word")
                    .font(.footnote)
                    .foregroundColor(Color("themeDark"))
                    .frame(maxWidth: .infinity)
            }
            
            Text("||")
            
            Button(action: {
                onSwipeRight()
            }) {
                Text("Start learning this word")
                    .font(.footnote)
                    .foregroundColor(Color("themeDark"))
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

