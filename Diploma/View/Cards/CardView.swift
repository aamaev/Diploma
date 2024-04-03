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
    
    let cardColors: [Color] = [
        .green,
        .teal,
        .pink,
        .indigo,
        .orange,
        .purple,
        .yellow,
        .green,
        .blue,
        .brown,
        .red
    ]
    
    var onSwipeLeft: () -> Void
    var onSwipeRight: () -> Void
    
    @State private var offset = CGSize.zero
    @State private var color: Color = .gray
    @State private var isOpen: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(color.gradient)
                .shadow(radius: 5)
            HStack {
                VStack(alignment: .center) {
                    HStack {
                        Text("Cards: \(title)")
                            .font(.subheadline)
                            .foregroundColor(.black)
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
                .padding(15)
            }
        }
        .padding(10)
        .offset(x: offset.width, y: offset.height)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    withAnimation {
                        changeColor(width: offset.width)
                    }
                }
                .onEnded { gesture in
                    withAnimation {
                        swipeCard(width: offset.width)
                    }
                }
        )
        
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
    
    func swipeCard(width: CGFloat) {
        switch width {
        case -500...(-150):
            offset = CGSize(width: -500, height: 0)
            onSwipeLeft()
        case 150...500:
            offset = CGSize(width: 500, height: 0)
            onSwipeRight()
        default:
            offset = .zero
        }
    }
    
    func changeColor(width: CGFloat) {
        switch width {
        case -500...(-130):
            color = .red
        case 130...500:
            color = .green
        default:
            color = .gray
        }
    }
}


