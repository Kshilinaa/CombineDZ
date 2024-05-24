//
//  ContentView.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 20.05.2024.
//

import SwiftUI
import Combine

struct ContentView: View {
    // MARK: - StateObject
    @StateObject var viewModel = ContentViewModel()
    //MARK: - Body
    var body: some View {
        VStack {
            Form {
                Section(header: Text("")) {
                    List(viewModel.dataToView, id: \.self) { item in
                        Text(item)
                    }
                }
            }
            HStack(spacing: 60) {
                addButtonView
                deleteButtonView
            }
            .frame(height: 50)
        }
    }
    // MARK: - Visual Components
    private var addButtonView: some View {
        Button("Добавить фрукт") {
            viewModel.addFruit()
        }
    }
    
    private var deleteButtonView: some View {
        Button("Удалить фрукт") {
            viewModel.deleteFruit()
        }
    }
}
#Preview {
    ContentView()
}
