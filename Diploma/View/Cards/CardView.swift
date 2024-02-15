//
//  CardView.swift
//  Diploma
//
//  Created by Артём Амаев on 15.02.24.
//

import SwiftUI

struct CardView: View {
    let word: String
    let translate: String
    
    @State private var isOpen: Bool = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 5)
            VStack {
                Text(word)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Button(action: {
                    isOpen.toggle()
                }, label: {
                    Text(translate)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .blur(radius: isOpen ? 0.2 : 7.0)
                })
            }
        }
    }

}

#Preview {
    CardView(word: "Лето", translate: "Summer")
}
