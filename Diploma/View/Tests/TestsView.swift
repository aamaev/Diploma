//
//  TestsView.swift
//  Diploma
//
//  Created by Артём Амаев on 8.02.24.
//

import SwiftUI

struct TestsView: View {
    @EnvironmentObject var viewModel: TestsViewModel
    @State private var searchText = ""
        
    var body: some View {
        List {
            Section(header: Text("Tests").font(.headline)) {
                ForEach(searchResults, id: \.id) { test in
                    NavigationLink(destination: TestDetailView(test: test, rules: test.rules)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(test.title)
                                    .font(.headline)
                                Text(test.rules)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            if let percentage = viewModel.getTestPersentage(forTestID: test.id) {
                                Text("\(String(format: "%.2f", percentage))%")
                                    .foregroundColor(.green)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText)
    }
    
    var searchResults: [Test] {
        if searchText.isEmpty {
            return viewModel.tests ?? []
        } else {
            return (viewModel.tests ?? []).filter { $0.title.contains(searchText) }
        }
    }
}



#Preview {
    TestsView()
}


