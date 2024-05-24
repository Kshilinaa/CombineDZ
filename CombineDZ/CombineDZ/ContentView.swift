//
//  ContentView.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 20.05.2024.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    enum Constants {
        static let numberText = "Введите число"
        static let chekText = "Проверить простоту числа"
    }
    
    @StateObject var viewModel = TaskViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            textFieldView
            chekButtonView
            Spacer()
                .frame(height: 20)
            resultTextView
            Spacer()
        }
    }
    
    private var textFieldView: some View {
        TextField(Constants.numberText, text: $viewModel.textFieldText)
            .textFieldStyle(.roundedBorder)
            .padding()
    }
    
    private var chekButtonView: some View {
        Button(Constants.chekText) {
            viewModel.check()
        }
    }
    
    private var resultTextView: some View {
        Text(viewModel.textToShow)
            .foregroundColor(.green)
    }
}

#Preview {
    ContentView()
}
