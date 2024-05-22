//
//  GuessNumberView.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 20.05.2024.
//

import SwiftUI
import Combine

struct GuessNumberView: View {
    
    // MARK: - Constants
    
    enum Constants {
        static let gameTitle = "Угадай число!"
        static let textFieldPlaceholder = "Введите число"
        static let loseTitle = "Загаданное число:"
        static let gameOver = "Завершить игру"
    }
    @StateObject private var viewModel = GuessTheNumberViewModel()
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack {
                headerView
                hiddenNumberView
                    .opacity(viewModel.shouldShowNumber ? 1.0 : 0.0)
                
                textFieldView
                messageView
                Spacer()
                gameOverButtonView
            }
            .padding()
        }
    }
    
    // MARK: - UI Elements
    
    private var hiddenNumberView: some View {
        VStack {
            Text(Constants.loseTitle)
                .font(.headline)
                .foregroundColor(.white)
            Text("\(viewModel.numberToGuess.value)")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
    
    private var headerView: some View {
        Text(Constants.gameTitle)
            .font(.largeTitle)
            .bold()
            .foregroundColor(.white)
            .padding()
            .cornerRadius(15)
            .shadow(radius: 100)
    }
    
    private var textFieldView: some View {
        VStack {
            TextField(
                Constants.textFieldPlaceholder,
                text: $viewModel.textFieldText
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numberPad)
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .shadow(radius: 5)
        }
        .padding()
    }
    
    private var messageView: some View {
        Text(viewModel.messageToShow)
            .font(.headline)
            .foregroundColor(.black)
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .shadow(radius: 5)
    }
    
    private var gameOverButtonView: some View {
        Button {
            viewModel.gameOver()
        } label: {
            Text(Constants.gameOver)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(15)
                .shadow(radius: 10)
        }
    }
}

#Preview {
    GuessNumberView()
}
