//
//  WelcomeInfoView.swift
//  Diploma
//
//  Created by Артём Амаев on 4.04.24.
//

import SwiftUI

struct InfoCards: Identifiable, Equatable {
    let id: UUID = .init()
    let color: Color
    let text: String
    let photo: String
}

struct WelcomeInfoView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var cards: [InfoCards] =
        [InfoCards(color: Color.indigo, text: "Develop communication skills with us by learning new words, improving grammar, and improving communication skills.", photo: "people-puzzles"),
         InfoCards(color: Color.indigo, text: "Improve your English everywhere! In lessons, with friends, in travel and even in moments of leisure.", photo: "person-alone"),
         InfoCards(color: Color.indigo, text: "Take the tests and assess your progress in learning English.", photo: "person-test")
        ]

    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(cards, id: \.id) { card in
                            RoundedRectangle(cornerRadius: 25)
                                .fill(card.color.gradient.opacity(0.3))
                                .padding(.horizontal, 15)
                                .containerRelativeFrame(.horizontal)
                                .overlay {
                                    VStack {
                                        Text(card.text).bold().font(.title2)
                                            .padding(40)
                                        Image(card.photo)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(30)
                                        
                                        if card == cards.last {
                                            Button(action: {
                                                Task {
                                                    await viewModel.firstLog()
                                                }
                                            }) {
                                               NavigationLink(destination: MainView()) {
                                                   Text("Continue")
                                                       .padding(10)
                                                       .foregroundColor(.white)
                                                       .background(Color.indigo.gradient)
                                                       .cornerRadius(8)
                                               }
                                               .padding(.bottom, 25)
                                            }
                                            .padding(.bottom, 25)
                                        }
                                    }
                                }
                        }
                    }
                    .overlay(alignment: .bottom) {
                        PagingIndicator(
                            activeTint: .black,
                            isActiveTint: .black.opacity(0.30),
                            opacityEffect: true,
                            clipEdges: false
                        )
                    }
                }
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
                .frame(height: 600)
            }
        }
    }
}

#Preview {
    WelcomeInfoView()
}
