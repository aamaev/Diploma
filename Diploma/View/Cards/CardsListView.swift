//
//  CardsListView.swift
//  Diploma
//
//  Created by Артём Амаев on 17.02.24.
//

import SwiftUI

struct CardsListView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @ObservedObject var viewModel = CardsViewModel()
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Cards").font(.largeTitle.bold())
                    .padding(.horizontal, 15)
                Spacer()
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.cards ?? [], id: \.id) { card in
                        NavigationLink(destination: CardsView(card: card)) {
                                RoundedRectangle(cornerRadius: 20)
                                    .aspectRatio(10.0 / 7.0, contentMode: .fit)
                                    .containerRelativeFrame(.horizontal,
                                                            count: verticalSizeClass == .regular ? 2 : 4,
                                                            spacing: 5)
                                    .foregroundStyle(card.color.gradient.opacity(0.65))
                                    .overlay(
                                        Text(card.title)
                                            .font(.title3.bold())
                                            .foregroundStyle(.black.gradient)

                                    )
                                    .scrollTransition { content, phase in
                                        content
                                            .opacity(phase.isIdentity ? 1.0 : 0.5)
                                            .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3,
                                                         y: phase.isIdentity ? 1.0 : 0.3)
                                            .offset(x: phase.isIdentity ? 0 : 50)
                                    }
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(16, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            
            Spacer()
        }
    }
}

#Preview {
    CardsListView(viewModel: CardsViewModel())
}
