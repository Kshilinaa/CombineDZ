//
//  BasketView.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 20.05.2024.
//

import SwiftUI
import Combine

/// Структура продукта
struct Product: Identifiable {
    /// Id
    var id = UUID()
    /// Название продукта
    var name: String
    /// Цена
    var price: Int
}

/// Структура для отображения корзину и продуктов
struct BasketView: View {
    @StateObject private var viewModel = BasketViewModel()
    
    var body: some View {
        VStack {
            productsView
            Spacer().frame(height: 20)
            basketListView
            Spacer()
            clearBasketButton
        }
        .padding()
    }
    
    /// Список продуктов с элементами управления для добавления/удаления продуктов.
    private var productsView: some View {
        VStack(alignment: .leading) {
            Text("Продукты ")
                .font(.title2)
                .bold()
                .padding(.bottom, 10)
            
            ForEach(viewModel.products.indices, id: \.self) { index in
                productRow(for: index)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    /// Создает строку для конкретного продукта.
    private func productRow(for index: Int) -> some View {
        HStack {
            Text(viewModel.products[index].name)
                .font(.headline)
            Spacer()
            Stepper("", value: Binding(
                get: {
                    viewModel.addedProducts.filter { $0.id == viewModel.products[index].id }.count
                },
                set: { newValue in
                    if newValue > 0 {
                        if !viewModel.addedProducts.contains(where: { $0.id == viewModel.products[index].id }) {
                            viewModel.addedProducts.append(viewModel.products[index])
                        }
                    } else {
                        if let position = viewModel.addedProducts.firstIndex(where: { $0.id == viewModel.products[index].id }) {
                            viewModel.addedProducts.remove(at: position)
                        }
                    }
                }
            ))
            .frame(width: 100)
        }
        .padding(.vertical, 5)
        .padding(.horizontal)
        .background(Color(.white))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    
    /// Список товаров в корзине и общей суммы.
    private var basketListView: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Товар")
                Spacer()
                Text("Цена")
            }
            .padding(.horizontal)
            .font(.custom("Verdana-bold", size: 20))
            
            ForEach(viewModel.check, id: \.id) { product in
                HStack {
                    Text(product.name)
                    Spacer()
                    Text("\(product.price) ₽")
                }
                .padding(.horizontal)
            }
            
            Spacer().frame(height: 10)
            
            Text("Итоговая сумма: \(viewModel.totalSum) ₽")
                .font(.title2)
                .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    /// Кнопка для очистки корзины.
    private var clearBasketButton: some View {
        Button {
            viewModel.clearBasket()
        } label: {
            Text("Очистить корзину")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.top)
    }
}


#Preview {
    BasketView()
}
