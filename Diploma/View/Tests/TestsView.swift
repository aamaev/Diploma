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
                ForEach(groupedTests.keys.sorted(), id: \.self) { title in
                    Section(header: Text(title).font(.headline)) {
                        ForEach(groupedTests[title] ?? [], id: \.id) { test in
                            NavigationLink(destination: TestDetailView(test: test, rules: test.rules)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(test.rules.localized())
                                            .font(.headline)
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
            return (viewModel.tests ?? []).filter { $0.title.localized().contains(searchText) }
        }
    }
    
    var groupedTests: [String: [Test]] {
        var dictionary = [String: [Test]]()
        searchResults.forEach { test in
            if var tests = dictionary[test.title] {
                tests.append(test)
                dictionary[test.title] = tests
            } else {
                dictionary[test.title] = [test]
            }
        }
        return dictionary
    }
}






