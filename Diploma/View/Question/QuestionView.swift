//
//  QuestionView.swift
//  Diploma
//
//  Created by Артём Амаев on 8.02.24.
//

import SwiftUI

struct QuestionView: View {
    @EnvironmentObject var viewModel: QuestionViewModel
    
    var body: some View {
        VStack {
            Button {
                print(viewModel.questions as Any)
            } label: {
                Text("Fetch questions")
            }
        }
        .padding(15)
        
    }
}

#Preview {
    QuestionView()
}
