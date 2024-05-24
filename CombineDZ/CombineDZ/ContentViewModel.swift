//
//  ContentViewModel.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 24.05.2024.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    //MARK: - Published
    @Published var dataToView: [String] = []
    //MARK: - Types
    var currentFruitIndex = 0
    var additionalFruits = ["Персик", "Мандарин", "Груша"]
    var cancellables: Set<AnyCancellable> = []
    // MARK: - Public Methods
    func addFruit() {
        calculateWhatToAdd()
    }
    
    func deleteFruit() {
        guard dataToView.count > 0 else { return }
        _ = dataToView.removeLast()
        if dataToView.count >= 3 {
            currentFruitIndex -= 1
        }
    }
    
    func calculateWhatToAdd() {
        switch dataToView.count {
        case 0:
            _ = Just("Яблоко (начальный)")
                .sink { [unowned self] item in
                    dataToView.append(item)
                }
        case 1:
            _ = Just("Банан (начальный)")
                .sink { [unowned self] item in
                    dataToView.append(item)
                }
        case 2:
            _ = Just("Апельсин (начальный)")
                .sink { [unowned self] item in
                    dataToView.append(item)
                }
        default:
            guard currentFruitIndex < additionalFruits.count else { return }
            _ = additionalFruits[currentFruitIndex...currentFruitIndex].publisher
                .sink { [unowned self] item in
                    print(item)
                    dataToView.append(item)
                    currentFruitIndex += 1
                }
        }
    }
}
