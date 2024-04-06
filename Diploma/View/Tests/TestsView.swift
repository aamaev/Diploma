//
//  TestsView.swift
//  Diploma
//
//  Created by Артём Амаев on 8.02.24.
//

import SwiftUI

struct TestsView: View {
    @ObservedObject var viewModel = TestsViewModel()
    @State private var searchText = ""
        
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Tests").font(.headline)) {
                    ForEach(searchResults, id: \.id) { test in
                        NavigationLink(destination: TestDetailView(test: test, rules: test.rules)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(test.title)
                                        .font(.headline)
                                    Text(test.rules.localized())
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
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
            .refreshable {
                Task {
                    await viewModel.fetchTests()
                    await viewModel.fetchTestPercentages()
                }
            }
        }
    }
    
    var searchResults: [Test] {
        if searchText.isEmpty {
            return viewModel.tests ?? []
        } else {
            return (viewModel.tests ?? []).filter { $0.title.contains(searchText) }
        }
    }
}






