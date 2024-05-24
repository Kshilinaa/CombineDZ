//
//  ContentView.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 20.05.2024.
//

import SwiftUI
import Combine

struct ContentView: View {
    //MARK: - Constants
    enum Constants {
        static let enterTitle = "Enter text"
        static let addTitle = "Добавить"
        static let cleanTitle = "Очистить список"
    }
    
    @ObservedObject var viewModel = ViewModelTextField()

    var body: some View {
        VStack {
            textFieldView
            HStack {
                buttonAddView
                cleanButtonView
            }
            listView
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
    
    private var textFieldView: some View {
        TextField(Constants.enterTitle, text: $viewModel.inputText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 3)
    }
    
    private var buttonAddView: some View {
        Button(action: {
            viewModel.addItem(viewModel.inputText)
        }) {
            Text(Constants.addTitle)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.inputText.isEmpty ? Color.gray.opacity(0.5) : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

        }
        .disabled(viewModel.inputText.isEmpty)
        .padding()
    }
    
    private var cleanButtonView: some View {
        Button(action: {
            viewModel.clearList()
        }) {
            Text(Constants.cleanTitle)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
    }
    
    private var listView: some View {
        List(viewModel.items, id: \.self) { item in
            Text(item)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
        }
        .listStyle(InsetGroupedListStyle())
    }
}
#Preview {
    ContentView()
}
