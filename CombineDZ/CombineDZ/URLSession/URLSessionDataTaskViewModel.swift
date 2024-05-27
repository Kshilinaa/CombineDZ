//
//  URLSessionDataTaskViewModel.swift
//  CombineDZ
//
//  Created by Ксения Шилина on 27.05.2024.
//


import Combine
import SwiftUI

class URLSessionDataTaskPublisherViewModel: ObservableObject {
    //MARK: - Types
    /// Переменная для хранения подписок
    var cancellables: Set<AnyCancellable> = []
    //MARK: - Published
    /// Данные для отображения
    @Published var dataToView: [Post] = []
    /// Изображение аватара
    @Published var avatarImage: Image?
    /// Ошибка для отображения в алерте
    @Published var alertError: ErrorForAlerrt?
    // MARK: - Public Methods
    /// Метод для загрузки данных
    func fetch() {
        /// Используем URLSessionDataTaskPublisher для загрузки данных изображения
        guard let url = URL(string: "https://via.placeholder.com/600/d32776") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .tryMap { data in
                guard let uiImage = UIImage(data: data) else {
                    throw AlertError(message: "No image")
                }
                return Image(uiImage: uiImage)
            }
            .receive(on: DispatchQueue.main)
            .replaceError(with: Image("blank"))
            .sink { [unowned self] image in
                avatarImage = image
            }
            .store(in: &cancellables)

    }
    
    
}
