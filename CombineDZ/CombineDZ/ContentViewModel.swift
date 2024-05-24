//
//  ContentViewModel.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 23.05.2024.
//

import Foundation
import Combine

/// Определите перечисление для недопустимого ввода
enum InvalidInput: String, Error, Identifiable {
    /// Возвращает строковое представление ошибки
    var id: String { rawValue }
    /// Ошибка для нечислового ввода
    case nonNumeric = "Введенное значение не является\nчислом"
}

/// Класс ContentViewModel, соответствующий протоколу ObservableObject
class ContentViewModel: ObservableObject {
    //MARK: - Published
    /// Публикуемая ошибка
    @Published var error: InvalidInput?
    /// Публикуемый массив строк для отображения данных
    @Published var dataToView: [String] = []
    
    //MARK: - Types
    /// Текущее значение из текстового поля
    var textFieldInput = CurrentValueSubject<String, Never>("")
    /// Значение для добавления
    var valueToAdd = CurrentValueSubject<String, Never>("")
    /// Массив строк (может содержать nil значения)
    var datas: [String?] = []
    /// Набор подписок Combine
    var cancellables: Set<AnyCancellable> = []
        
    // MARK: - Initializers
    init() {
        /// Подписка на изменения valueToAdd
        valueToAdd
            .dropFirst() // Пропустить первое значение
            .sink { [unowned self] newValue in
                /// Добавить новое значение в datas
                datas.append(newValue)
                /// Очистить dataToView
                dataToView.removeAll()
                /// Вызвать метод fetch для обновления dataToView
                fetch()
            }
            .store(in: &cancellables) // Сохранить подписку
        
        /// Присвоить значение valueToAdd в textFieldInput
        valueToAdd
            .assign(to: \.value, on: textFieldInput)
            .store(in: &cancellables) // Сохранить подписку
    }
    // MARK: - Public Methods
    /// Метод для добавления значения в список
    func addToList() {
        /// Проверка значения из textFieldInput и подписка на результат
        _ = validate(value: textFieldInput.value)
            .sink { [unowned self] completion in
                /// Обработка завершения проверки
                switch completion {
                case .failure(let error):
                    /// Установка ошибки
                    self.error = error
                case .finished:
                    break
                }
            } receiveValue: { [unowned self] value in
                /// Если проверка прошла успешно, присвоить значение в valueToAdd
                valueToAdd.value = value
            }
    }
    
    /// Метод для проверки значения
    func validate(value: String) -> AnyPublisher<String, InvalidInput> {
        if isNonNumeric(input: value) {
            /// Если значение не числовое, вернуть ошибку
            return Fail(error: InvalidInput.nonNumeric)
                .eraseToAnyPublisher()
        } else {
            /// Если значение числовое, сбросить ошибку и вернуть значение
            error = nil
            return Just(value)
                .setFailureType(to: InvalidInput.self)
                .eraseToAnyPublisher()
        }
    }
    
    /// Метод для проверки, является ли ввод нечисловым
    func isNonNumeric(input: String) -> Bool {
        if input.isEmpty || input == " " {
            return true
        }
        for char in input {
            if !char.isNumber {
                return true
            }
        }
        return false
    }
    
    /// Метод для получения данных и обновления dataToView
    func fetch() {
        _ = datas.publisher
            .flatMap { item -> AnyPublisher<String, Never> in
                if let item = item {
                    return Just(item)
                        .eraseToAnyPublisher()
                } else {
                    return Empty(completeImmediately: true)
                        .eraseToAnyPublisher()
                }
            }
            .sink { [unowned self] item in
                dataToView.append(item)
            }
    }
    
    /// Метод для очистки списка данных
    func clearList() {
        datas.removeAll()
        dataToView.removeAll()
        error = nil
        textFieldInput.value = ""
    }
}
