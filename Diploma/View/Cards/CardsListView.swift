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
    
    @State var isAddingCard = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.cards ?? [], id: \.id) { card in
                            NavigationLink(destination: CardsView(card: card)) {
                                RoundedRectangle(cornerRadius: 20)
                                    .aspectRatio(10.0 / 7.0, contentMode: .fit)
                                    .foregroundStyle(card.color.gradient.opacity(0.65))
                                    .containerRelativeFrame(.horizontal,
                                                            count: verticalSizeClass == .regular ? 2 : 4,
                                                            spacing: 5)
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
                .navigationTitle("Cards")
                .contentMargins(16, for: .scrollContent)
                .scrollTargetBehavior(.viewAligned)
                
                HStack {
                    Text("CardsListView.MyCards").bold()
                    
                    Spacer()
                    
                    Button(action: {
                        isAddingCard = true
                    }, label: {
                       Image(systemName: "plus")
                    })
                    .sheet(isPresented: $isAddingCard, content: {
                        AddCardView(viewModel: viewModel, isPresented: $isAddingCard)
                    })
                }
                .padding()
                
                List {
                    ForEach(viewModel.userCards ?? [], id: \.id) { userCard in
                        ZStack(alignment: .leading) {
                            NavigationLink(destination: CardsView(card: userCard)) {
                                EmptyView()
                            }.opacity(0.0)

                            Text(userCard.title).bold()
                        }
                    }
                    .onDelete(perform: delete)
                }
                .scrollContentBackground(.hidden)
                
                Spacer()
            }
            
        }
        
    }
}

func delete(at offsets: IndexSet){
    //arrayOfOrders.remove(atOffsets: offsets)
}

#Preview {
    CardsListView(viewModel: CardsViewModel())
}
