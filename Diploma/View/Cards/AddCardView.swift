//
//  AddCardView.swift
//  Diploma
//
//  Created by Артём Амаев on 3.04.24.
//

import SwiftUI

struct AddCardView: View {
    @ObservedObject var viewModel: CardsViewModel
    
    @Binding var isPresented: Bool
    @State var stackName = ""
    @State var words: [(String, String)] = [("","")]
    @State var showError = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    TextField("Card Name", text: $stackName)
                        .padding()
                        .padding(.top, 30)
                    
                    ForEach(words.indices, id: \.self) { index in
                        HStack {
                            TextField("Word", text: $words[index].0)
                            TextField("Translation", text: $words[index].1)
                        }
                        .padding()
                    }
                    
                    Button(action: {
                        words.append(("",""))
                    }, label: {
                        Image(systemName: "plus.app")
                    })
                    .padding(.vertical, 10)
                    
                    Button(action: {
                        if stackName.isEmpty || words.contains(where: { $0.0.isEmpty || $0.1.isEmpty }) {
                            showError = true
                        } else {
                            Task {
                                await viewModel.addCard(stackName: stackName, words: words)
                            }
                            isPresented = false
                        }
                    }, label: {
                        Text("Save")
                    })
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    .alert(isPresented: $showError) {
                        Alert(title: Text("Error"), message: Text("Please fill in all fields"), dismissButton: .default(Text("OK")))
                    }
                }
                .navigationBarItems(leading: Text("New card stack").bold())
                .navigationBarItems(trailing: Button("Cancel") {
                    isPresented = false
                })
            }
        }
    }
}


#Preview {
    AddCardView(viewModel: CardsViewModel(),
                isPresented: .constant(true))
}
