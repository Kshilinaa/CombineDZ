//
//  ContentView.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 20.05.2024.
//
import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    //MARK: - Body
    
    var body: some View {
            VStack {
                Spacer()
                VStack {
                    textFieldView
                    HStack(spacing: 50) {
                        addButtonView
                        cleanButtonView
                    }
                    .padding()
                    textView
                }
                listView
                
            }
        }
    // MARK: - Visual Components
    private var textFieldView: some View {
        TextField("Введите число", text: $viewModel.textFieldInput.value)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
    }
    
    private var addButtonView: some View {
        Button("Добавить") {
            viewModel.addToList()
        }
    }
    
    private var cleanButtonView: some View {
        Button("Очистить список") {
            viewModel.clearList()
        }
    }
    
    private var textView: some View {
        Text(viewModel.error?.rawValue ?? "")
            .foregroundColor(.red)
    }
    private var listView: some View {
        List(viewModel.dataToView, id: \.self) { item in
            Text(item)
        }
        .font(.title)
    }
}


#Preview {
    ContentView()
}
