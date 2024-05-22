//
//  TaxiViewModel.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 21.05.2024.
//
/// ЗАДАНИЕ TASK3
import SwiftUI
import Foundation
import Combine

class TaxiViewModel: ObservableObject {
    // MARK: - Published
    @Published var data = ""
    @Published var status = ""
    //MARK: - Types
    private var cancellable: AnyCancellable?
    // MARK: - Life Cycle
    init() {
        cancellable = $data
            .dropFirst()
            .map { [unowned self] value -> String in
                self.status = "Ищем машину..."
                return value
            }
            .delay(for: 7, scheduler: DispatchQueue.main)
            .sink { [unowned self] value in
                self.data = "Водитель приедет через 10 минут"
                self.status = "Машина найдена"
            }
    }
    // MARK: - Public Methods
    func refresh() {
        data = "Идет поиск свободных машин..."
    }
    
    func cancel() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.status = "Заказ отменен"
            self.cancellable?.cancel()
            self.cancellable = nil
            self.data = ""
        }
    }
    
}
