//
//  NewMessageView.swift
//  Diploma
//
//  Created by Артём Амаев on 21.02.24.
//

import SwiftUI

struct NewMessageView: View {
    @EnvironmentObject var viewModel: ChatViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(viewModel.users ?? [], id: \.id) { user in
                    Text(user.userName)
                }
            }
            .navigationTitle("New message")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

#Preview {
    NewMessageView()
}
