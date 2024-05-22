//
//  ContentView.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 20.05.2024.
//
import SwiftUI
import Combine

struct FirstPipelineView: View {
    
    @StateObject var viewModel = FirstPipelineViewModel()
    
    var body: some View {
        VStack {
            HStack {
                TextField("Ваше имя", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                Text(viewModel.nameValidation)
            }
            .padding()
            
            HStack {
                TextField("Ваша фамилия", text: $viewModel.surname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                Text(viewModel.surnameValidation)
            }
            .padding()
        }
    }
}

class FirstPipelineViewModel: ObservableObject {
    @Published var name = ""
    @Published var surname = ""
    @Published var nameValidation = ""
    @Published var surnameValidation = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        /// Валидация имени
        $name
            .map { $0.isEmpty ? "❌" : "✅" }
            .assign(to: \.nameValidation, on: self)
            .store(in: &cancellables)
        
        /// Валидация фамилии
        $surname
            .map { $0.isEmpty ? "❌" : "✅" }
            .assign(to: \.surnameValidation, on: self)
            .store(in: &cancellables)
    }
}

#Preview {
    FirstPipelineView()
}
