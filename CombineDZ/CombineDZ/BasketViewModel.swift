//
//  BasketViewModel.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 22.05.2024.
//

import Foundation
import Combine

/// ViewModel для управления состоянием корзины.
class BasketViewModel: ObservableObject {
    @Published var addedProducts: [Product] = []
    @Published var check: [Product] = []
    @Published var totalSum = 0

    /// Список доступных продуктов.
    var products: [Product] = [
        .init(name: "Хлеб 1шт", price: 50),
        .init(name: "Молоко 1л", price: 100),
        .init(name: "Форель морская 1кг", price: 1100),
        .init(name: "Сыр 200г", price: 150),
        .init(name: "Шоколад 100г", price: 120),
        .init(name: "Краб Камчатский 500г", price: 2800),
        .init(name: "Чай 100г", price: 80)
    ]
    
    private var сancellable: Set<AnyCancellable> = []
    
    /// Очищает корзину.
    func clearBasket() {
        сancellable.removeAll()
        check.removeAll()
        addedProducts.removeAll()
        totalSum = 0
    }
  
    init() {
        $addedProducts
            .map { products in
                products.filter { $0.price <= 1000 }
            }
            .sink { [unowned self] products in
                check = products
            }
            .store(in: &сancellable)
        
        $check
            .dropFirst()
            .scan(100) { accumulatedSum, newProducts in
                accumulatedSum + newProducts.reduce(0) { $0 + $1.price }
            }
            .sink { sum in
                self.totalSum = sum
            }
            .store(in: &сancellable)
        
        $check
            .dropFirst()
            .combineLatest($addedProducts)
            .map { check, addedProducts -> Int in
                let filteredCheck = check.filter { product in
                    addedProducts.contains { $0.id == product.id }
                }
                return 100 + filteredCheck.reduce(0) { $0 + $1.price }
            }
            .sink { [unowned self] sum in
                self.totalSum = sum
            }
            .store(in: &сancellable)
    }
    
}
