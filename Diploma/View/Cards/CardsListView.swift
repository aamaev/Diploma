//
//  CardsListView.swift
//  Diploma
//
//  Created by Артём Амаев on 17.02.24.
//

import SwiftUI

struct CardsListView: View {
    @ObservedObject var viewModel = CardsViewModel()
    
    var body: some View {
        List {
            Section(header: Text("Cards").font(.headline)) {
                ForEach(viewModel.cards ?? [], id: \.id) { card in
                    NavigationLink(destination: CardsView(card: card)) {
                        VStack(alignment: .leading) {
                            Text(card.title)
                                .font(.headline)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CardsListView()
}
