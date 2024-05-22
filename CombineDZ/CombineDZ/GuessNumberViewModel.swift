//
//  GuessNumberViewModel.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 22.05.2024.
//

import SwiftUI
import Combine

final class GuessTheNumberViewModel: ObservableObject {
    
    // MARK: - Constats
    enum Constants {
        static let smallNumberTitle = "Введенное число меньше загаданного"
        static let bigNumberTitle = "Введенное число больше загаданного"
        static let equal = "Вы угадали!"
    }
    
    var numberToGuess = CurrentValueSubject<Int, Never>(Int.random(in: 0...100))
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Published
    
    @Published var textFieldText = ""
    @Published var shouldShowNumber = false
    @Published var messageToShow = ""
    
    // MARK: - Initializers
    
    init() {
        $textFieldText
            .dropFirst(2)
            .map { text -> Int in
                guard let guessedNumber = Int(text) else { return 0 }
                return guessedNumber
            }
            .delay(for: 0.2, scheduler: DispatchQueue.main)
            .sink { [unowned self] guessedNumber in
                self.compareNumbers(guessedNumber)

            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methodes
    
    func compareNumbers(_ guessedNumber: Int) {
        let actualNumber = numberToGuess.value
        if guessedNumber < actualNumber {
            messageToShow = Constants.smallNumberTitle
        } else if guessedNumber > actualNumber {
            messageToShow = Constants.bigNumberTitle
        } else {
            messageToShow = Constants.equal
        }
    }
    
    func gameOver() {
        cancellables.removeAll()
        shouldShowNumber = true
    }
    
}

